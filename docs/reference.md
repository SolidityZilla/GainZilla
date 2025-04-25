# Solidity API

## Context

### Contract
Context : contracts/reference.sol

 --- 
### Functions:
### _msgSender

```solidity
function _msgSender() internal view virtual returns (address)
```

## IERC20

### Contract
IERC20 : contracts/reference.sol

 --- 
### Functions:
### totalSupply

```solidity
function totalSupply() external view returns (uint256)
```

### balanceOf

```solidity
function balanceOf(address account) external view returns (uint256)
```

### transfer

```solidity
function transfer(address recipient, uint256 amount) external returns (bool)
```

### allowance

```solidity
function allowance(address owner, address spender) external view returns (uint256)
```

### approve

```solidity
function approve(address spender, uint256 amount) external returns (bool)
```

### transferFrom

```solidity
function transferFrom(address sender, address recipient, uint256 amount) external returns (bool)
```

 --- 
### Events:
### Transfer

```solidity
event Transfer(address from, address to, uint256 value)
```

### Approval

```solidity
event Approval(address owner, address spender, uint256 value)
```

## SafeMath

### Contract
SafeMath : contracts/reference.sol

 --- 
### Functions:
### add

```solidity
function add(uint256 a, uint256 b) internal pure returns (uint256)
```

### sub

```solidity
function sub(uint256 a, uint256 b) internal pure returns (uint256)
```

### sub

```solidity
function sub(uint256 a, uint256 b, string errorMessage) internal pure returns (uint256)
```

### mul

```solidity
function mul(uint256 a, uint256 b) internal pure returns (uint256)
```

### div

```solidity
function div(uint256 a, uint256 b) internal pure returns (uint256)
```

### div

```solidity
function div(uint256 a, uint256 b, string errorMessage) internal pure returns (uint256)
```

## Ownable

### Contract
Ownable : contracts/reference.sol

 --- 
### Modifiers:
### onlyOwner

```solidity
modifier onlyOwner()
```

 --- 
### Functions:
### constructor

```solidity
constructor() public
```

### owner

```solidity
function owner() public view returns (address)
```

### transferOwnership

```solidity
function transferOwnership(address newOwner) public virtual
```

_Transfers ownership of the contract to a new account (`newOwner`).
Can only be called by the current owner._

### _transferOwnership

```solidity
function _transferOwnership(address newOwner) internal virtual
```

_Transfers ownership of the contract to a new account (`newOwner`).
Internal function without access restriction._

### renounceOwnership

```solidity
function renounceOwnership() public virtual
```

 --- 
### Events:
### OwnershipTransferred

```solidity
event OwnershipTransferred(address previousOwner, address newOwner)
```

## IUniswapV2Pair

### Contract
IUniswapV2Pair : contracts/reference.sol

 --- 
### Functions:
### name

```solidity
function name() external pure returns (string)
```

### symbol

```solidity
function symbol() external pure returns (string)
```

### decimals

```solidity
function decimals() external pure returns (uint8)
```

### totalSupply

```solidity
function totalSupply() external view returns (uint256)
```

### balanceOf

```solidity
function balanceOf(address owner) external view returns (uint256)
```

### allowance

```solidity
function allowance(address owner, address spender) external view returns (uint256)
```

### approve

```solidity
function approve(address spender, uint256 value) external returns (bool)
```

### transfer

```solidity
function transfer(address to, uint256 value) external returns (bool)
```

### transferFrom

```solidity
function transferFrom(address from, address to, uint256 value) external returns (bool)
```

### DOMAIN_SEPARATOR

```solidity
function DOMAIN_SEPARATOR() external view returns (bytes32)
```

### PERMIT_TYPEHASH

```solidity
function PERMIT_TYPEHASH() external pure returns (bytes32)
```

### nonces

```solidity
function nonces(address owner) external view returns (uint256)
```

### permit

```solidity
function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external
```

### MINIMUM_LIQUIDITY

```solidity
function MINIMUM_LIQUIDITY() external pure returns (uint256)
```

### factory

```solidity
function factory() external view returns (address)
```

### token0

```solidity
function token0() external view returns (address)
```

### token1

```solidity
function token1() external view returns (address)
```

### getReserves

```solidity
function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast)
```

### price0CumulativeLast

```solidity
function price0CumulativeLast() external view returns (uint256)
```

### price1CumulativeLast

```solidity
function price1CumulativeLast() external view returns (uint256)
```

### kLast

```solidity
function kLast() external view returns (uint256)
```

### mint

```solidity
function mint(address to) external returns (uint256 liquidity)
```

### burn

```solidity
function burn(address to) external returns (uint256 amount0, uint256 amount1)
```

### swap

```solidity
function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes data) external
```

### skim

```solidity
function skim(address to) external
```

### sync

```solidity
function sync() external
```

### initialize

```solidity
function initialize(address, address) external
```

 --- 
### Events:
### Approval

```solidity
event Approval(address owner, address spender, uint256 value)
```

### Transfer

```solidity
event Transfer(address from, address to, uint256 value)
```

### Mint

```solidity
event Mint(address sender, uint256 amount0, uint256 amount1)
```

### Burn

```solidity
event Burn(address sender, uint256 amount0, uint256 amount1, address to)
```

### Swap

```solidity
event Swap(address sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, address to)
```

### Sync

```solidity
event Sync(uint112 reserve0, uint112 reserve1)
```

## IUniswapV2Factory

### Contract
IUniswapV2Factory : contracts/reference.sol

 --- 
### Functions:
### createPair

```solidity
function createPair(address tokenA, address tokenB) external returns (address pair)
```

## IUniswapV2Router02

### Contract
IUniswapV2Router02 : contracts/reference.sol

 --- 
### Functions:
### swapExactTokensForETHSupportingFeeOnTransferTokens

```solidity
function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] path, address to, uint256 deadline) external
```

### swapExactTokensForTokensSupportingFeeOnTransferTokens

```solidity
function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] path, address to, uint256 deadline) external
```

### factory

```solidity
function factory() external pure returns (address)
```

### WETH

```solidity
function WETH() external pure returns (address)
```

### addLiquidityETH

```solidity
function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity)
```

### quote

```solidity
function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) external pure returns (uint256 amountB)
```

### getAmountOut

```solidity
function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) external pure returns (uint256 amountOut)
```

### getAmountIn

```solidity
function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) external pure returns (uint256 amountIn)
```

### getAmountsOut

```solidity
function getAmountsOut(uint256 amountIn, address[] path) external view returns (uint256[] amounts)
```

### getAmountsIn

```solidity
function getAmountsIn(uint256 amountOut, address[] path) external view returns (uint256[] amounts)
```

## IERC20Extented

### Contract
IERC20Extented : contracts/reference.sol

 --- 
### Functions:
### decimals

```solidity
function decimals() external view virtual returns (uint8)
```

### name

```solidity
function name() external view virtual returns (string)
```

### symbol

```solidity
function symbol() external view virtual returns (string)
```

inherits IERC20:
### totalSupply

```solidity
function totalSupply() external view returns (uint256)
```

### balanceOf

```solidity
function balanceOf(address account) external view returns (uint256)
```

### transfer

```solidity
function transfer(address recipient, uint256 amount) external returns (bool)
```

### allowance

```solidity
function allowance(address owner, address spender) external view returns (uint256)
```

### approve

```solidity
function approve(address spender, uint256 amount) external returns (bool)
```

### transferFrom

```solidity
function transferFrom(address sender, address recipient, uint256 amount) external returns (bool)
```

 --- 
### Events:
inherits IERC20:
### Transfer

```solidity
event Transfer(address from, address to, uint256 value)
```

### Approval

```solidity
event Approval(address owner, address spender, uint256 value)
```

## gainZilla

### Contract
gainZilla : contracts/reference.sol

 --- 
### Modifiers:
### lockTheSwap

```solidity
modifier lockTheSwap()
```

 --- 
### Functions:
### constructor

```solidity
constructor() public
```

### name

```solidity
function name() external pure returns (string)
```

### symbol

```solidity
function symbol() external pure returns (string)
```

### decimals

```solidity
function decimals() external pure returns (uint8)
```

### totalSupply

```solidity
function totalSupply() external pure returns (uint256)
```

### balanceOf

```solidity
function balanceOf(address account) public view returns (uint256)
```

### isBot

```solidity
function isBot(address account) public view returns (bool)
```

### transfer

```solidity
function transfer(address recipient, uint256 amount) external returns (bool)
```

### allowance

```solidity
function allowance(address owner, address spender) external view returns (uint256)
```

### approve

```solidity
function approve(address spender, uint256 amount) external returns (bool)
```

### transferFrom

```solidity
function transferFrom(address sender, address recipient, uint256 amount) external returns (bool)
```

### pairPrice

```solidity
function pairPrice() public view returns (uint256)
```

### openTrading

```solidity
function openTrading(uint256 botBlocks) external
```

### enableToken

```solidity
function enableToken() external
```

### disableToken

```solidity
function disableToken() external
```

### disablePauseAbility

```solidity
function disablePauseAbility() external
```

### manualswap

```solidity
function manualswap() external
```

### manualsend

```solidity
function manualsend() external
```

### manualSendToken

```solidity
function manualSendToken(address token) external
```

### receive

```solidity
receive() external payable
```

### excludeFromFee

```solidity
function excludeFromFee(address account) public
```

### includeInFee

```solidity
function includeInFee(address account) external
```

### removeBot

```solidity
function removeBot(address account) external
```

### addBot

```solidity
function addBot(address account) external
```

### disableBlackListing

```solidity
function disableBlackListing() external
```

### setTransferTransactionMultiplier

```solidity
function setTransferTransactionMultiplier(uint256 _multiplier) external
```

### setMaxWalletAmount

```solidity
function setMaxWalletAmount(uint256 maxWalletAmount) external
```

### setBuyTaxes

```solidity
function setBuyTaxes(uint256 marketingFee, uint256 liquidityFee, uint256 teamFee, uint256 ecosystemFee) external
```

### setSellTaxes

```solidity
function setSellTaxes(uint256 marketingFee, uint256 liquidityFee, uint256 teamFee, uint256 ecosystemFee) external
```

### disableTaxChange

```solidity
function disableTaxChange() external
```

### updateEcosystemAddress

```solidity
function updateEcosystemAddress(address payable ecosystemAddress) external
```

### updateMarketingAddress

```solidity
function updateMarketingAddress(address payable marketingAddress) external
```

### updateTeamAddress

```solidity
function updateTeamAddress(address payable teamAddress) external
```

### updateLpRecipient

```solidity
function updateLpRecipient(address payable lpRecipient) external
```

### updateNumTokensToSwap

```solidity
function updateNumTokensToSwap(uint256 numTokens) external
```

### configureStrongHands

```solidity
function configureStrongHands(bool enabled, uint32 duration) external
```

### cooldownRemaining

```solidity
function cooldownRemaining(address account) public view returns (uint256 days_, uint256 hours_, uint256 minutes_, uint256 seconds_)
```

inherits Ownable:
### owner

```solidity
function owner() public view returns (address)
```

### transferOwnership

```solidity
function transferOwnership(address newOwner) public virtual
```

_Transfers ownership of the contract to a new account (`newOwner`).
Can only be called by the current owner._

### _transferOwnership

```solidity
function _transferOwnership(address newOwner) internal virtual
```

_Transfers ownership of the contract to a new account (`newOwner`).
Internal function without access restriction._

### renounceOwnership

```solidity
function renounceOwnership() public virtual
```

inherits IERC20Extented:
inherits IERC20:

 --- 
### Events:
### MaxTxAmountUpdated

```solidity
event MaxTxAmountUpdated(uint256 _maxTxAmount)
```

### BuyFeesUpdated

```solidity
event BuyFeesUpdated(uint256 _buyMarketingFee, uint256 _buyLiquidityFee, uint256 _buyTeamFee, uint256 _buyEcosystemFee)
```

### SellFeesUpdated

```solidity
event SellFeesUpdated(uint256 _sellMarketingFee, uint256 _sellLiquidityFee, uint256 _sellTeamFee, uint256 _sellEcosystemFee)
```

inherits Ownable:
### OwnershipTransferred

```solidity
event OwnershipTransferred(address previousOwner, address newOwner)
```

inherits IERC20Extented:
inherits IERC20:
### Transfer

```solidity
event Transfer(address from, address to, uint256 value)
```

### Approval

```solidity
event Approval(address owner, address spender, uint256 value)
```

