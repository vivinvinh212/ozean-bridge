// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {OptimismMintableERC20} from "../../src/tokens/L2Token.sol";
import {IL2StandardBridge} from "../../src/interfaces/StandardBridge.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "forge-std/console.sol";


/**
 * @title BridgeL2ToL1
 * @dev Script to bridge tokens from Ozean L2 to Sepolia L1
 */
contract BridgeL2ToL1 is Script {
    // Default parameters
    uint32 constant DEFAULT_L1_GAS = 200000; // Default gas limit on L1
    uint256 constant DEFAULT_AMOUNT = 100 * 10**18; // 100 tokens with 18 decimals

    // L2 Standard Bridge address on Ozean (predefined address from OP Stack)
    address constant L2_STANDARD_BRIDGE = 0x4200000000000000000000000000000000000010;

    function run() public {
        // Get the bridging parameters from environment variables or use defaults
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(privateKey);
        address l2TokenAddress = vm.envAddress("L2_TOKEN_ADDRESS");
        uint256 bridgeAmount = vm.envOr("BRIDGE_AMOUNT", DEFAULT_AMOUNT);
        
        console.log("Sender address:", deployer);
        console.log("L2 Token address:", l2TokenAddress);
        console.log("Amount to bridge back to L1:", bridgeAmount);

        // Start broadcasting transactions
        vm.startBroadcast(privateKey);
        
        // Get instances of the token and bridge
        OptimismMintableERC20 l2Token = OptimismMintableERC20(l2TokenAddress);
        IL2StandardBridge bridge = IL2StandardBridge(L2_STANDARD_BRIDGE);
        
        // Check token balance
        uint256 balance = l2Token.balanceOf(deployer);
        require(balance >= bridgeAmount, "Insufficient token balance");
        console.log("Current balance:", balance);
        
        // Bridge the tokens back to L1
        bridge.withdrawERC20(
            l2TokenAddress,
            bridgeAmount,
            DEFAULT_L1_GAS,
            "" // No extra data
        );
        
        console.log("Withdrawal initiated from L2 to L1");
        console.log("Note: Withdrawal will need to be finalized on L1 after the challenge period");
        
        vm.stopBroadcast();
    }
}