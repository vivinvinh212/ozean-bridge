// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {OptimismMintableERC20} from "../../src/tokens/L2Token.sol";
import "forge-std/console.sol";


/**
 * @title DeployL2Token
 * @dev Script to deploy the L2 token on Ozean testnet
 */
contract DeployL2Token is Script {
    // The L2 token configuration
    string constant TOKEN_NAME = "Ozean Bridge Test Token";
    string constant TOKEN_SYMBOL = "OBTT";
    uint8 constant TOKEN_DECIMALS = 18;
    
    // L2 Bridge address on Ozean testnet (predefined address from OP Stack)
    address constant L2_STANDARD_BRIDGE = 0x4200000000000000000000000000000000000010;

    function run() public returns (OptimismMintableERC20) {
        // Get the deployer address from the private key
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(privateKey);
        console.log("Deployer address:", deployer);

        // Get the L1 token address from environment
        address l1TokenAddress = vm.envAddress("L1_TOKEN_ADDRESS");
        console.log("L1 Token address:", l1TokenAddress);

        // Deploy the token
        vm.startBroadcast(privateKey);
        
        OptimismMintableERC20 token = new OptimismMintableERC20(
            L2_STANDARD_BRIDGE,
            l1TokenAddress,
            TOKEN_NAME,
            TOKEN_SYMBOL,
            TOKEN_DECIMALS
        );
        
        vm.stopBroadcast();

        // Output token details
        console.log("L2 Token deployed to:", address(token));
        console.log("Token name:", token.name());
        console.log("Token symbol:", token.symbol());
        console.log("Token decimals:", token.decimals());
        console.log("Remote token:", token.remoteToken());
        console.log("Bridge:", token.bridge());

        return token;
    }
}