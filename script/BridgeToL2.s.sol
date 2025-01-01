// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "forge-std/Script.sol";

interface ICustomBridge {
    function bridgeERC20(
        address _localToken,
        address _remoteToken,
        uint256 _amount,
        uint32 _minGasLimit,
        bytes calldata _extraData
    ) external;
}

contract BridgeToL2 is Script {
    function run() external {
        // 1. Load environment variables
        address l1Token = vm.envAddress("L1_TOKEN_ADDRESS");
        address l1Bridge = vm.envAddress("L1_BRIDGE_ADDRESS");
        address l2Token = vm.envAddress("L2_TOKEN_ADDRESS");
        uint256 amount = vm.envUint("BRIDGE_AMOUNT");
        uint32 minGasLimit = 200000; // adjust as needed

        console.log("------------------");
        console.log("Starting Bridge Tokens Script");
        console.log("L1 Token:", l1Token);
        console.log("L1 Bridge:", l1Bridge);
        console.log("L2 Token:", l2Token);
        console.log("Amount to Bridge:", amount);
        console.log("------------------");

        /**
         * STEP 1: Bridge tokens to L2
         */
        console.log("STEP 1: Bridge tokens from L1 to L2");
        vm.startBroadcast();
        ICustomBridge(l1Bridge).bridgeERC20(
            l1Token,
            l2Token,
            amount,
            minGasLimit,
            bytes("") // Add any extra data here
        );
        vm.stopBroadcast();
        console.log("Bridge transaction broadcasted");
        console.log("------------------");

        console.log("Bridge Tokens Script finished successfully!");
    }
}
