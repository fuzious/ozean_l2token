// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "forge-std/Script.sol";
import "src/OzeanAsset.sol";

contract DeployOzeanAsset is Script {
    function run() external {
        // Load environment variables
        string memory name = vm.envString("TOKEN_NAME_L1");
        string memory symbol = vm.envString("TOKEN_SYMBOL");
        address initialOwner = msg.sender;

        // Start broadcasting transactions
        vm.startBroadcast();

        // Deploy the contract
        OzeanAsset token = new OzeanAsset(initialOwner);

        // Output the address of the deployed contract
        console.log("OzeanAsset deployed to:", address(token));

        // Stop broadcasting transactions
        vm.stopBroadcast();
    }
}
