// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title L1Token
 * @dev An ERC20 token to be deployed on Sepolia L1 for bridging to Ozean testnet
 * Created for Ozean Smart Contract Engineering test task
 */
contract L1Token is ERC20, Ownable {
    uint8 private immutable _decimals;

    /**
     * @dev Constructor for the L1Token
     * @param name Name of the token
     * @param symbol Symbol of the token
     * @param decimalsValue Decimals for the token (defaults to 18)
     * @param initialSupply Initial supply to mint to the deployer
     * @param initialOwner Address that will receive initial tokens and become owner
     */
    constructor(
        string memory name,
        string memory symbol,
        uint8 decimalsValue,
        uint256 initialSupply,
        address initialOwner
    ) ERC20(name, symbol) Ownable(initialOwner) {
        _decimals = decimalsValue;
        _mint(initialOwner, initialSupply);
    }

    /**
     * @dev Override decimals function to use a custom value
     */
    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }

    /**
     * @dev Mint additional tokens (only owner can call)
     * @param to Address to receive new tokens
     * @param amount Amount of tokens to mint
     */
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    /**
     * @dev Burns tokens from the caller's address
     * @param amount Amount of tokens to burn
     */
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}