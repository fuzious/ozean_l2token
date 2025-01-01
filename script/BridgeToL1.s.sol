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

contract BridgeToL1 is Script {
    function run() external {
        // 1. Load environment variables
        address l1Token = vm.envAddress("L1_TOKEN_ADDRESS");
        address l2Bridge = vm.envAddress("L2_BRIDGE_ADDRESS");
        address l2Token = vm.envAddress("L2_TOKEN_ADDRESS");
        uint256 amount = vm.envUint("BRIDGE_AMOUNT");
        uint32 minGasLimit = 200000; // adjust as needed

        console.log("------------------");
        console.log("Starting Bridge Tokens Script");
        console.log("L1 Token:", l1Token);
        console.log("L2 Bridge:", l2Bridge);
        console.log("L2 Token:", l2Token);
        console.log("Amount to Bridge:", amount);
        console.log("------------------");

        /**
         * STEP 1: Bridge tokens to L1
         */
        console.log("STEP 1: Bridge tokens from L2 to L1");
        vm.startBroadcast();
        ICustomBridge(l2Bridge).bridgeERC20(
            l2Token,
            l1Token,
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
