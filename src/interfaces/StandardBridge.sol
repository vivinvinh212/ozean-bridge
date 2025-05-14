// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title IL1StandardBridge
 * @dev Interface for the L1 Standard Bridge from the OP Stack
 */
interface IL1StandardBridge {
    /**
     * @dev Bridges ERC20 tokens from L1 to L2
     * @param _l1Token Address of the L1 token
     * @param _l2Token Address of the L2 token
     * @param _amount Amount of tokens to bridge
     * @param _minGasLimit Minimum gas limit for the L2 transaction
     * @param _extraData Extra data to be sent with the transaction
     */
    function depositERC20(
        address _l1Token,
        address _l2Token,
        uint256 _amount,
        uint32 _minGasLimit,
        bytes calldata _extraData
    ) external;

    /**
     * @dev Bridges ERC20 tokens from L1 to L2 to a specified recipient
     * @param _l1Token Address of the L1 token
     * @param _l2Token Address of the L2 token
     * @param _to Address of the recipient on L2
     * @param _amount Amount of tokens to bridge
     * @param _minGasLimit Minimum gas limit for the L2 transaction
     * @param _extraData Extra data to be sent with the transaction
     */
    function depositERC20To(
        address _l1Token,
        address _l2Token,
        address _to,
        uint256 _amount,
        uint32 _minGasLimit,
        bytes calldata _extraData
    ) external;

    /**
     * @dev Finalizes the withdrawal of ERC20 tokens from L2 to L1
     * @param _l1Token Address of the L1 token
     * @param _l2Token Address of the L2 token
     * @param _from Address of the sender on L2
     * @param _to Address of the recipient on L1
     * @param _amount Amount of tokens to withdraw
     * @param _extraData Extra data sent with the transaction
     */
    function finalizeERC20Withdrawal(
        address _l1Token,
        address _l2Token,
        address _from,
        address _to,
        uint256 _amount,
        bytes calldata _extraData
    ) external;
}

/**
 * @title IL2StandardBridge
 * @dev Interface for the L2 Standard Bridge from the OP Stack
 */
interface IL2StandardBridge {
    /**
     * @dev Withdraws tokens from L2 to L1 (legacy function - not supported with custom gas token)
     * @param _l2Token Address of the L2 token
     * @param _amount Amount of tokens to withdraw
     * @param _minGasLimit Minimum gas limit for the L1 transaction
     * @param _extraData Extra data to be sent with the transaction
     */
    function withdraw(
        address _l2Token,
        uint256 _amount,
        uint32 _minGasLimit,
        bytes calldata _extraData
    ) external payable;

    /**
     * @dev Withdraws tokens from L2 to L1 to a specified recipient (legacy function - not supported with custom gas token)
     * @param _l2Token Address of the L2 token
     * @param _to Address of the recipient on L1
     * @param _amount Amount of tokens to withdraw
     * @param _minGasLimit Minimum gas limit for the L1 transaction
     * @param _extraData Extra data to be sent with the transaction
     */
    function withdrawTo(
        address _l2Token,
        address _to,
        uint256 _amount,
        uint32 _minGasLimit,
        bytes calldata _extraData
    ) external payable;

    /**
     * @dev Bridges ERC20 tokens (inherited from StandardBridge)
     * @param _localToken Address of the token on the local chain
     * @param _remoteToken Address of the token on the remote chain
     * @param _amount Amount of tokens to bridge
     * @param _minGasLimit Minimum gas limit for the transaction
     * @param _extraData Extra data to be sent with the transaction
     */
    function bridgeERC20(
        address _localToken,
        address _remoteToken,
        uint256 _amount,
        uint32 _minGasLimit,
        bytes calldata _extraData
    ) external;

    /**
     * @dev Bridges ERC20 tokens to a specified recipient (inherited from StandardBridge)
     * @param _localToken Address of the token on the local chain
     * @param _remoteToken Address of the token on the remote chain
     * @param _to Address of the recipient
     * @param _amount Amount of tokens to bridge
     * @param _minGasLimit Minimum gas limit for the transaction
     * @param _extraData Extra data to be sent with the transaction
     */
    function bridgeERC20To(
        address _localToken,
        address _remoteToken,
        address _to,
        uint256 _amount,
        uint32 _minGasLimit,
        bytes calldata _extraData
    ) external;

    /**
     * @dev Returns the address of the corresponding L1 bridge
     * @return Address of the L1 bridge
     */
    function l1TokenBridge() external view returns (address);
}