// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {L1Token} from "../../src/tokens/L1Token.sol";
import "forge-std/console.sol";


/**
 * @title DeployL1Token
 * @dev Script to deploy the L1 token on Sepolia testnet
 */
contract DeployL1Token is Script {
    // Token configuration
    string constant TOKEN_NAME = "Ozean Bridge Test Token";
    string constant TOKEN_SYMBOL = "OBTT";
    uint8 constant TOKEN_DECIMALS = 18;
    uint256 constant INITIAL_SUPPLY = 1_000_000 * 10**18; // 1 million tokens with 18 decimals

    function run() public returns (L1Token) {
        // Get the deployer address from the private key
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(privateKey);
        console.log("Deployer address:", deployer);

        // Deploy the token
        vm.startBroadcast(privateKey);
        
        L1Token token = new L1Token(
            TOKEN_NAME,
            TOKEN_SYMBOL,
            TOKEN_DECIMALS,
            INITIAL_SUPPLY,
            deployer
        );
        
        vm.stopBroadcast();

        // Output token details
        console.log("L1 Token deployed to:", address(token));
        console.log("Token name:", token.name());
        console.log("Token symbol:", token.symbol());
        console.log("Token decimals:", token.decimals());
        console.log("Total supply:", token.totalSupply());
        console.log("Deployer balance:", token.balanceOf(deployer));

        return token;
    }
}