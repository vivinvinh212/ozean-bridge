// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC165} from "@openzeppelin/contracts/utils/introspection/IERC165.sol";

/**
 * @title IOptimismMintableERC20
 * @dev Interface for the OptimismMintableERC20 token standard.
 * This interface must be implemented by tokens on Ozean to be compatible with the OP Standard Bridge.
 */
interface IOptimismMintableERC20 is IERC165 {
    /**
     * @dev Returns the address of the corresponding token on the other chain (L1 or L2).
     */
    function remoteToken() external view returns (address);

    /**
     * @dev Returns the address of the bridge on this chain (L1 or L2) that should be allowed
     * to mint/burn this token.
     */
    function bridge() external view returns (address);

    /**
     * @dev Mints tokens to the specified account. Only callable by the bridge.
     * @param _to Address to mint tokens to
     * @param _amount Amount of tokens to mint
     */
    function mint(address _to, uint256 _amount) external;

    /**
     * @dev Burns tokens from the specified account. Only callable by the bridge.
     * @param _from Address to burn tokens from
     * @param _amount Amount of tokens to burn
     */
    function burn(address _from, uint256 _amount) external;
}

/**
 * @title OptimismMintableERC20
 * @dev Implementation of the IOptimismMintableERC20 interface for Ozean L2 token
 * Compatible with the OP Standard Bridge
 */
contract OptimismMintableERC20 is ERC20, IOptimismMintableERC20 {
    // The address of the L1 token that this token represents
    address public immutable override remoteToken;
    // The address of the L2 standard bridge that should be allowed to mint/burn this token
    address public immutable override bridge;
    // ERC20 decimal places
    uint8 private immutable _decimals;

    /**
     * @dev Constructor for the OptimismMintableERC20
     * @param _bridge Address of the L2 standard bridge
     * @param _remoteToken Address of the corresponding L1 token
     * @param _name Name of the token
     * @param _symbol Symbol of the token
     * @param _decimalsValue Decimals for the token (defaults to 18)
     */
    constructor(
        address _bridge,
        address _remoteToken,
        string memory _name,
        string memory _symbol,
        uint8 _decimalsValue
    ) ERC20(_name, _symbol) {
        bridge = _bridge;
        remoteToken = _remoteToken;
        _decimals = _decimalsValue;
    }

    /**
     * @dev Override decimals function to use a custom value
     */
    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }

    /**
     * @dev Mints tokens to the specified address. Can only be called by the bridge.
     * @param _to Address to mint tokens to
     * @param _amount Amount of tokens to mint
     */
    function mint(address _to, uint256 _amount) external override {
        require(msg.sender == bridge, "OptimismMintableERC20: only bridge can mint");
        _mint(_to, _amount);
    }

    /**
     * @dev Burns tokens from the specified address. Can only be called by the bridge.
     * @param _from Address to burn tokens from
     * @param _amount Amount of tokens to burn
     */
    function burn(address _from, uint256 _amount) external override {
        require(msg.sender == bridge, "OptimismMintableERC20: only bridge can burn");
        _burn(_from, _amount);
    }

    /**
     * @dev Implementation of IERC165 interface
     * @param _interfaceId The interface ID to check support for
     * @return True if the interface is supported
     */
    function supportsInterface(bytes4 _interfaceId) external pure returns (bool) {
        return _interfaceId == type(IOptimismMintableERC20).interfaceId || 
               _interfaceId == type(IERC165).interfaceId;
    }
}