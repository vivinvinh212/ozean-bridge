// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "forge-std/console.sol";


/**
 * @title CheckBalances
 * @dev Utility script to check token balances on both L1 and L2
 */
contract CheckBalances is Script {
    function run() public view {
        // Get addresses from environment
        address user = vm.envAddress("USER_ADDRESS");
        address l1Token = vm.envAddress("L1_TOKEN_ADDRESS");
        address l2Token = vm.envAddress("L2_TOKEN_ADDRESS");
        
        console.log("Checking balances for:", user);
        console.log("====================================");
        
        // Check L1 balance (if connected to Sepolia)
        try IERC20(l1Token).balanceOf(user) returns (uint256 balance) {
            console.log("L1 Token Balance:", balance);
            console.log("L1 Token Address:", l1Token);
        } catch {
            console.log("Could not read L1 balance (wrong network?)");
        }
        
        // Check L2 balance (if connected to Ozean)
        try IERC20(l2Token).balanceOf(user) returns (uint256 balance) {
            console.log("L2 Token Balance:", balance);
            console.log("L2 Token Address:", l2Token);
        } catch {
            console.log("Could not read L2 balance (wrong network?)");
        }
    }
}