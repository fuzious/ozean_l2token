// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "forge-std/Script.sol";
import "../src/OzeanAssetL2.sol";

contract DeployOzeanAssetL2 is Script {
    function run() external {
        // Load environment variables
        address l2Bridge = vm.envAddress("L2_BRIDGE_ADDRESS"); // L2 bridge address (e.g., L2StandardBridge)
        address l1Token = vm.envAddress("L1_TOKEN_ADDRESS");   // Corresponding L1 token address
        string memory name = vm.envString("TOKEN_NAME_L2");       // ERC20 token name
        string memory symbol = vm.envString("TOKEN_SYMBOL");   // ERC20 token symbol

        vm.startBroadcast();

        // Deploy the OzeanAssetL2 contract
        OzeanAssetL2 l2Token = new OzeanAssetL2(l2Bridge, l1Token, name, symbol);

        vm.stopBroadcast();

        // Log the deployed contract address
        console.log("OzeanAssetL2 deployed at:", address(l2Token));
    }
}
