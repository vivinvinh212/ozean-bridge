// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {L1Token} from "../../src/tokens/L1Token.sol";
import {IL1StandardBridge} from "../../src/interfaces/StandardBridge.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "forge-std/console.sol";


/**
 * @title BridgeL1ToL2
 * @dev Script to bridge tokens from Sepolia L1 to Ozean Testnet L2
 */
contract BridgeL1ToL2 is Script {
    // Default parameters
    uint32 constant DEFAULT_L2_GAS = 200000; // Default gas limit on L2
    uint256 constant DEFAULT_AMOUNT = 1000 * 10**18; // 1000 tokens with 18 decimals

    // L1 Standard Bridge address on Sepolia
    // Note: This address needs to be confirmed for the Sepolia <> Ozean bridge
    address constant L1_STANDARD_BRIDGE = 0x4200000000000000000000000000000000000010;

    function run() public {
        // Get the bridging parameters from environment variables or use defaults
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(privateKey);
        address l1TokenAddress = vm.envAddress("L1_TOKEN_ADDRESS");
        address l2TokenAddress = vm.envAddress("L2_TOKEN_ADDRESS");
        uint256 bridgeAmount = vm.envOr("BRIDGE_AMOUNT", DEFAULT_AMOUNT);
        
        console.log("Sender address:", deployer);
        console.log("L1 Token address:", l1TokenAddress);
        console.log("L2 Token address:", l2TokenAddress);
        console.log("Amount to bridge:", bridgeAmount);

        // Start broadcasting transactions
        vm.startBroadcast(privateKey);
        
        // Get instances of the token and bridge
        L1Token l1Token = L1Token(l1TokenAddress);
        IL1StandardBridge bridge = IL1StandardBridge(L1_STANDARD_BRIDGE);
        
        // Check and approve token spending
        uint256 balance = l1Token.balanceOf(deployer);
        require(balance >= bridgeAmount, "Insufficient token balance");
        console.log("Current balance:", balance);
        
        // Approve the bridge to spend tokens
        l1Token.approve(L1_STANDARD_BRIDGE, bridgeAmount);
        console.log("Approved bridge to spend tokens");
        
        // Bridge the tokens to L2
        bridge.depositERC20(
            l1TokenAddress,
            l2TokenAddress,
            bridgeAmount,
            DEFAULT_L2_GAS,
            "" // No extra data
        );
        
        console.log("Tokens bridged to L2");
        
        vm.stopBroadcast();
    }
}