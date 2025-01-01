// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "forge-std/Script.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IL1MintableToken is IERC20 {
    function mint(address to, uint256 amount) external;
}

contract AirdropAndApprove is Script {
    function run() external {
        // 1. Load environment variables
        address l1Token = vm.envAddress("L1_TOKEN_ADDRESS");
        address l1Bridge = vm.envAddress("L1_BRIDGE_ADDRESS");
        uint256 amount = vm.envUint("BRIDGE_AMOUNT");

        console.log("------------------");
        console.log("Starting Airdrop and Approve Script");
        console.log("L1 Token:", l1Token);
        console.log("L1 Bridge:", l1Bridge);
        console.log("Amount to Approve:", amount);
        console.log("------------------");

        /**
         * STEP 1: Mint tokens (Airdrop)
         */
        console.log("STEP 1: Mint tokens to sender");
        vm.startBroadcast();
        IL1MintableToken(l1Token).mint(msg.sender, amount);
        vm.stopBroadcast();
        console.log("Mint transaction broadcasted");
        console.log("------------------");

        /**
         * STEP 2: Approve the Bridge to spend tokens
         */
        console.log("STEP 2: Approve the Bridge");
        vm.startBroadcast();
        IERC20(l1Token).approve(l1Bridge, amount);
        vm.stopBroadcast();
        console.log("Approve transaction broadcasted");
        console.log("------------------");

        console.log("Airdrop and Approve Script finished successfully!");
    }
}
