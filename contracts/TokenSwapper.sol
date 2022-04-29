// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenSwapper is Ownable {
    address public _token;
    address public _desiredToken;
    address public _destinationAddress;
    address public _uniswapRouterAddress;

    constructor (address token, address desiredToken, address routerAddress) {
        _uniswapRouterAddress = routerAddress;
        _token = token;
        _desiredToken = desiredToken;
        _destinationAddress = address(this);
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
     * @dev Updates the token to be swapped. Can only be called by the current owner.
     */
     
    function updateTokenAddress(address token) external onlyOwner {
        _token = token;
    }

    /**
     * @dev Updates the token to be swapped to. Can only be called by the current owner.
     */
    function updateDesiredTokenAddress(address desiredToken) external onlyOwner {
        _desiredToken = desiredToken;
    }

    /**
     * @dev Updates the destination address of the token swap result. Can only be called by the current owner.
    */
    function updateDestinationAddress(address destinationAddress) external onlyOwner {
        _destinationAddress = destinationAddress;
    }

    /**
     * @dev Updates the Uniswap/Pancakeswap Router address. Can only be called by the current owner.
     */
    function updateRouterAddress (address router) external onlyOwner {
        _uniswapRouterAddress = router;
    }

    /**
     * @dev Swaps _token to _desiredToken and sends the result to _destinationAddress.
     */
    function swapTokens() public {
        uint balance = IERC20(_token).balanceOf(address(this));
        require(balance > 0, "There are not any tokens to swap");

        IERC20(_token).approve(_uniswapRouterAddress, balance);

        address[] memory path = new address[](2);
        path[0] = _token;
        path[1] = _desiredToken;
        
        IUniswapV2Router02(_uniswapRouterAddress).swapExactTokensForTokens(
            balance, 
            1,
            path, 
            _destinationAddress, 
            block.timestamp + 120
        );
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