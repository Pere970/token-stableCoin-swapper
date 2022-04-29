// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IERC20.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract TokenUtilities is OwnableUpgradeable {

    address public _routerAddress;
    address public _factoryAddress;
    address public _chainToken;

    function initialize(address routerAddress, address factoryAddress, address chainToken) public initializer{
        _routerAddress = routerAddress;
        _factoryAddress = factoryAddress;
        _chainToken = chainToken;
        __Ownable_init();
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    function createPair(address tokenA, address tokenB) external onlyOwner {
        IUniswapV2Factory(_factoryAddress).createPair(tokenA, tokenB);
    }

    function getPair(address tokenA, address tokenB) external view returns (address pair){
        return IUniswapV2Factory(_factoryAddress).getPair(tokenA, tokenB);
    }

    function addLiquidityETH(address token, uint amountTokenDesired) external payable onlyOwner{
        IERC20(token).approve(_routerAddress, amountTokenDesired); 
        IUniswapV2Router02(_routerAddress).addLiquidityETH{value: msg.value}(
            token, 
            amountTokenDesired, 
            1, 
            1, 
            address(this), 
            block.timestamp
        );
    }

    function removeLiquidityETH(address token, uint256 liquidity) external onlyOwner {
        address lpAddress = IUniswapV2Factory(_factoryAddress).getPair(token, _chainToken);
        require (lpAddress != address(0));
        IERC20(lpAddress).approve(_routerAddress, liquidity);
        IUniswapV2Router02(_routerAddress).removeLiquidityETH(
            token, 
            liquidity, 
            1, 
            1, 
            address(this), 
            block.timestamp
        );
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner override (OwnableUpgradeable) {
        super._transferOwnership(newOwner);
    }

     /**
     * @dev Returns the current owner of the contract.
     */
    function owner() public virtual view override (OwnableUpgradeable) returns (address){
        return super.owner();
    }

    /**
     * @dev Updates the Uniswap/Pancakeswap Router address. Can only be called by the current owner.
     */
    function updateRouterAddress (address router) external onlyOwner {
        _routerAddress = router;
    }

    /**
     * @dev Updates the Uniswap/Pancakeswap Factory address. Can only be called by the current owner.
     */
    function updateFactoryAddress (address factory) external onlyOwner {
        _factoryAddress = factory;
    }

    /**
     * @dev Updates the chainToken address. Can only be called by the current owner.
     */
    function updatechainTokenAddress (address chainToken) external onlyOwner {
        _chainToken = chainToken;
    }

    /**
     * @dev Returns the balance of a given token. 
     */
    function getBalance(address token) external view returns (uint256 balance) {
        return IERC20(token).balanceOf(address(this));
    }

    /**
     * @dev Withdraws a given token's balance to the owner address. Can only be called by the current owner.
     */
    function withdrawTokens(address token) external onlyOwner {
        require(IERC20(token).balanceOf(address(this)) > 0, "Not enough tokens to withdraw!");
        IERC20(token).transfer(msg.sender, IERC20(token).balanceOf(address(this)));
    }
}