// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract TokenSwapper is OwnableUpgradeable {
    address public _destinationAddress;
    address public _routerAddress;

    function initialize(address routerAddress) public initializer {
        _routerAddress = routerAddress;
        _destinationAddress = address(this);
        __Ownable_init();
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

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
     * @dev Updates the destination address of the token swap result. Can only be called by the current owner.
    */
    function updateDestinationAddress(address destinationAddress) external onlyOwner {
        _destinationAddress = destinationAddress;
    }

    /**
     * @dev Updates the Uniswap/Pancakeswap Router address. Can only be called by the current owner.
     */
    function updateRouterAddress (address router) external onlyOwner {
        _routerAddress = router;
    }

    /**
     * @dev Swaps _token to _desiredToken and sends the result to _destinationAddress.
     */
    function swapTokens(address tokenToSwap, address destinationToken) public {
        uint balance = IERC20(tokenToSwap).balanceOf(address(this));
        require(balance > 0, "There are not any tokens to swap");

        IERC20(tokenToSwap).approve(_routerAddress, balance);

        address[] memory path = new address[](2);
        path[0] = tokenToSwap;
        path[1] = destinationToken;
        
        IUniswapV2Router02(_routerAddress).swapExactTokensForTokens(
            balance, 
            1,
            path, 
            _destinationAddress, 
            block.timestamp
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