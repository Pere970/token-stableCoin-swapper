// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IERC20.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenUtilities is Ownable {

    address public _uniswapRouterAddress;
    address public _uniswapFactoryAddress;
    address public _WETH;

    constructor(address uniswapRouterAddress, address uniswapFactoryAddress, address weth){
        _uniswapRouterAddress = uniswapRouterAddress;
        _uniswapFactoryAddress = uniswapFactoryAddress;
        _WETH = weth;
    }

    function createPair(address tokenA, address tokenB) external onlyOwner returns (address pair) {
        return IUniswapV2Factory(_uniswapFactoryAddress).createPair(tokenA, tokenB);
    }

    function addLiquidityETH(address token,uint amountTokenDesired) external payable onlyOwner
    returns (uint amountToken, uint amountETH, uint liquidity){
        IERC20(token).approve(_uniswapRouterAddress, amountTokenDesired); 
        return IUniswapV2Router02(_uniswapRouterAddress).addLiquidityETH{value: msg.value}(
            token, 
            amountTokenDesired, 
            1, 
            1, 
            address(this), 
            block.timestamp + 120
        );
    }

    function removeLiquidityETH(address token, uint liquidity) external onlyOwner returns (uint amountToken, uint amountETH){
        address lpAddress = IUniswapV2Factory(_uniswapFactoryAddress).getPair(token, _WETH);
        IERC20(lpAddress).approve(_uniswapRouterAddress, liquidity); 
        return IUniswapV2Router02(_uniswapRouterAddress).removeLiquidityETH(
            token, 
            liquidity, 
            1, 
            1, 
            address(this), 
            block.timestamp + 120
        );
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner override (Ownable) {
        super._transferOwnership(newOwner);
    }

     /**
     * @dev Returns the current owner of the contract.
     */
    function owner() public virtual view override (Ownable) returns (address){
        return super.owner();
    }

    /**
     * @dev Updates the Uniswap/Pancakeswap Router address. Can only be called by the current owner.
     */
    function updateRouterAddress (address router) external onlyOwner {
        _uniswapRouterAddress = router;
    }

    /**
     * @dev Updates the Uniswap/Pancakeswap Factory address. Can only be called by the current owner.
     */
    function updateFactoryAddress (address factory) external onlyOwner {
        _uniswapFactoryAddress = factory;
    }

    /**
     * @dev Updates the WETH address. Can only be called by the current owner.
     */
    function updateWETHAddress (address weth) external onlyOwner {
        _WETH = weth;
    }

    /**
     * @dev Withdraws a given token's balance to the owner address. Can only be called by the current owner.
     */
    function withdrawTokens(address token) external onlyOwner {
        require(IERC20(token).balanceOf(address(this)) > 0, "Not enough tokens to withdraw!");
        IERC20(token).transfer(msg.sender, IERC20(token).balanceOf(address(this)));
    }
}