// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts@4.9.3/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.9.3/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

interface IUniswapV2Router {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint, uint, uint);
    function swapExactTokensForETH(
        uint amountIn, 
        uint amountOutMin, 
        address[] calldata path, 
        address to, 
        uint deadline
    ) external returns (uint[] memory amounts);
}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IUniswapV2Pair {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function token0() external view returns (address);
    function token1() external view returns (address);
}

contract MemeCoin is ERC20, Ownable {
    using SafeMath for uint256;

    uint256 private constant TOTAL_SUPPLY = 1_000_000_000 * 10**18;
    uint256 public maxWalletPercentage = 100;
    uint256 private constant BP_DIVISOR = 10_000;

    struct TaxRates {
        uint16 buyLp;
        uint16 buyEco;
        uint16 sellLp;
        uint16 sellEco;
    }
    TaxRates public taxRates;
    uint256 private constant TRANSFER_MULTIPLIER = 35; // Made constant

    uint256 public swapThreshold = TOTAL_SUPPLY / 1000;
    uint256 public accumulatedLp;
    uint256 public accumulatedEco;
    bool private swapping;

    struct CooldownConfig {
        bool enabled;
        uint32 duration;
        mapping(address => uint256) cooldowns;
    }
    CooldownConfig public cooldown;

    struct DiamondFloor {
        bool enabled;
        uint16 triggerPercentage;
        uint256 athPrice;
        bool sellStopped;
        uint256 blockedAth;
    }
    DiamondFloor public diamondFloor;

    address public routerAddress;
    address public pairAddress;
    address private constant DEFAULT_ROUTER = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    mapping(address => bool) public isExempt;

    event RouterUpdated(address newRouter);
    event TaxesCollected(uint256 lpAmount, uint256 ecoAmount);
    event LiquidityAdded(uint256 tokenAmount, uint256 ethAmount);
    event MaxWalletUpdated(uint256 newPercentage);

    constructor() ERC20("Meme Coin", "MEME") {
        _transferOwnership(msg.sender);
        _mint(msg.sender, TOTAL_SUPPLY);
        routerAddress = DEFAULT_ROUTER;
        _setupPair();
        
        taxRates = TaxRates(0, 0, 0, 0);
        
        isExempt[msg.sender] = true;
        isExempt[address(this)] = true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual override {
        require(amount > 0, "Transfer amount must be >0");

        bool isBuy = sender == pairAddress && !isExempt[recipient];
        bool isSell = recipient == pairAddress && !isExempt[sender];

        // Diamond Floor check
        if (diamondFloor.enabled && isSell) {
            require(!diamondFloor.sellStopped, "Sells stopped by Diamond Floor");
            _checkPriceConditions();
        }

        // Cooldown check
        if (cooldown.enabled && isSell) {
            require(block.timestamp >= cooldown.cooldowns[sender], "Cooldown active");
            cooldown.cooldowns[sender] = block.timestamp + cooldown.duration;
        }

        uint256 taxAmount = _calculateTax(sender, recipient, amount);
        uint256 netAmount = amount.sub(taxAmount);

        // Max wallet check
        if (!isExempt[recipient] && !isSell) {
            require(
                balanceOf(recipient).add(netAmount) <= _maxWalletSize(),
                "Max wallet exceeded"
            );
        }

        // Process taxes
        if (taxAmount > 0) {
            super._transfer(sender, address(this), taxAmount);
            _distributeTax(taxAmount, isBuy, isSell);
        }

        // Execute transfer
        super._transfer(sender, recipient, netAmount);

        // Auto LP addition
        if (_shouldSwapBack()) {
            _swapAndLiquify();
        }
    }

    function _calculateTax(
        address sender,
        address recipient,
        uint256 amount
    ) private view returns (uint256) {
        if (isExempt[sender] || isExempt[recipient]) return 0;

        bool isBuy = sender == pairAddress;
        bool isSell = recipient == pairAddress;

        if (isBuy) {
            return amount.mul(uint256(taxRates.buyLp).add(taxRates.buyEco)).div(BP_DIVISOR);
        } 
        if (isSell) {
            return amount.mul(uint256(taxRates.sellLp).add(taxRates.sellEco)).div(BP_DIVISOR);
        }
        
        uint256 sellTotal = uint256(taxRates.sellLp).add(taxRates.sellEco);
        uint256 transferTax = sellTotal.mul(TRANSFER_MULTIPLIER).div(10);
        return amount.mul(transferTax).div(BP_DIVISOR);
    }

    function _distributeTax(uint256 taxAmount, bool isBuy, bool isSell) private {
        uint256 lpShare;
        uint256 ecoShare;

        if (isBuy) {
            uint256 total = uint256(taxRates.buyLp).add(taxRates.buyEco);
            require(total > 0, "Buy tax not set");
            lpShare = taxAmount.mul(taxRates.buyLp).div(total);
        } else if (isSell) {
            uint256 total = uint256(taxRates.sellLp).add(taxRates.sellEco);
            require(total > 0, "Sell tax not set");
            lpShare = taxAmount.mul(taxRates.sellLp).div(total);
        } else {
            uint256 total = uint256(taxRates.sellLp).add(taxRates.sellEco);
            require(total > 0, "Transfer tax not set");
            lpShare = taxAmount.mul(taxRates.sellLp).div(total).mul(TRANSFER_MULTIPLIER).div(10);
        }

        ecoShare = taxAmount.sub(lpShare);
        accumulatedLp = accumulatedLp.add(lpShare);
        accumulatedEco = accumulatedEco.add(ecoShare);

        emit TaxesCollected(lpShare, ecoShare);
    }

    function _checkPriceConditions() private {
        uint256 currentPrice = pairPrice();
        if (currentPrice == 0) return;

        if (currentPrice > diamondFloor.athPrice) {
            diamondFloor.athPrice = currentPrice;
            diamondFloor.sellStopped = false;
            return;
        }

        uint256 thresholdPrice = diamondFloor.athPrice
            .mul(BP_DIVISOR.sub(diamondFloor.triggerPercentage))
            .div(BP_DIVISOR);

        if (currentPrice < thresholdPrice) {
            diamondFloor.sellStopped = true;
            diamondFloor.blockedAth = diamondFloor.athPrice;
        }

        if (diamondFloor.sellStopped && currentPrice >= diamondFloor.blockedAth.mul(2)) {
            diamondFloor.sellStopped = false;
            diamondFloor.athPrice = currentPrice;
        }
    }

    function _swapAndLiquify() private {
        uint256 totalTokens = accumulatedLp.add(accumulatedEco);
        if (totalTokens < swapThreshold) return;

        swapping = true;
        uint256 initialBalance = address(this).balance;

        // Process ecosystem tax
        _swapTokensForETH(accumulatedEco);
        uint256 ecoETH = address(this).balance.sub(initialBalance);
        payable(owner()).transfer(ecoETH);

        // Process LP tax
        uint256 lpTokens = accumulatedLp;
        uint256 half = lpTokens.div(2);
        _swapTokensForETH(half);
        
        uint256 lpETH = address(this).balance.sub(ecoETH);
        _addLiquidity(lpTokens.sub(half), lpETH);

        accumulatedLp = 0;
        accumulatedEco = 0;
        swapping = false;
    }

    function pairPrice() public view returns (uint256) {
        (uint112 reserve0, uint112 reserve1,) = IUniswapV2Pair(pairAddress).getReserves();
        if (reserve0 == 0 || reserve1 == 0) return 0;
        
        return IUniswapV2Pair(pairAddress).token0() == address(this) ?
            uint256(reserve1).mul(1e18).div(uint256(reserve0)) :
            uint256(reserve0).mul(1e18).div(uint256(reserve1));
    }

    function cooldownRemaining(address account) public view returns (
        uint256 days_, 
        uint256 hours_, 
        uint256 minutes_, 
        uint256 seconds_
    ) {
        uint256 remaining = cooldown.cooldowns[account] > block.timestamp ? 
            cooldown.cooldowns[account].sub(block.timestamp) : 0;
        
        days_ = remaining.div(86400);
        remaining %= 86400;
        hours_ = remaining.div(3600);
        remaining %= 3600;
        minutes_ = remaining.div(60);
        seconds_ = remaining % 60;
    }

    function priceDeviation() public view returns (int256) {
        if (diamondFloor.athPrice == 0) return 0;
        uint256 currentPrice = pairPrice();
        return currentPrice > diamondFloor.athPrice ?
            int256(currentPrice.sub(diamondFloor.athPrice).mul(1e18).div(diamondFloor.athPrice)) :
            -int256(diamondFloor.athPrice.sub(currentPrice).mul(1e18).div(diamondFloor.athPrice));
    }

    function setRouter(address newRouter) external onlyOwner {
        routerAddress = newRouter;
        _setupPair();
        emit RouterUpdated(newRouter);
    }

    function setTaxRates(uint16 buyLp, uint16 buyEco, uint16 sellLp, uint16 sellEco) external onlyOwner {
        require(buyLp + buyEco <= 2500, "Max 25% buy tax");
        require(sellLp + sellEco <= 2500, "Max 25% sell tax");
        taxRates = TaxRates(buyLp, buyEco, sellLp, sellEco);
    }

    function setThreshold(uint256 threshold) external onlyOwner {
        swapThreshold = threshold;
    }

    function configureCooldown(bool enabled, uint32 duration) external onlyOwner {
        cooldown.enabled = enabled;
        cooldown.duration = duration * 1 minutes;
    }

    function configureDiamondFloor(bool enabled, uint16 triggerPercent) external onlyOwner {
        require(triggerPercent <= BP_DIVISOR, "Invalid percentage");
        diamondFloor.enabled = enabled;
        diamondFloor.triggerPercentage = triggerPercent;
    }

    function setExempt(address account, bool exempt) external onlyOwner {
        isExempt[account] = exempt;
    }

    function _setupPair() private {
        pairAddress = IUniswapV2Factory(IUniswapV2Router(routerAddress).factory())
            .createPair(address(this), IUniswapV2Router(routerAddress).WETH());
    }

    function _swapTokensForETH(uint256 amount) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = IUniswapV2Router(routerAddress).WETH();

        _approve(address(this), routerAddress, amount);
        IUniswapV2Router(routerAddress).swapExactTokensForETH(
            amount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        _approve(address(this), routerAddress, tokenAmount);
        IUniswapV2Router(routerAddress).addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0,
            0,
            owner(),
            block.timestamp
        );
        emit LiquidityAdded(tokenAmount, ethAmount);
    }

    function _maxWalletSize() public view returns (uint256) {
        return TOTAL_SUPPLY.mul(maxWalletPercentage).div(BP_DIVISOR);
    }

    function _shouldSwapBack() private view returns (bool) {
        return !swapping &&
            accumulatedLp.add(accumulatedEco) >= swapThreshold &&
            msg.sender != pairAddress;
    }

    function setMaxWalletPercentage(uint256 percentage) external onlyOwner {
        require(percentage >= 100, "Max 1% wallet limit");
        maxWalletPercentage = percentage;
        emit MaxWalletUpdated(percentage);
    }

    receive() external payable {}
}