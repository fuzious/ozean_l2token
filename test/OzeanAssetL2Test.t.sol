// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/OzeanAssetL2.sol";

contract OzeanAssetL2Test is Test {
    OzeanAssetL2 private ozeanAssetL2;

    // Addresses for testing
    address private bridge = address(0x123);
    address private remoteToken = address(0x456);
    address private user = address(0x789);
    uint256 private constant MINT_AMOUNT = 1e18; // 1 token

    function setUp() public {
        // Deploy the OzeanAssetL2 contract
        ozeanAssetL2 = new OzeanAssetL2(bridge, remoteToken, "OzeanAsset", "OZA");
    }

    function testConstructorInitialization() public {
        // Test if the contract is initialized with correct values
        assertEq(ozeanAssetL2.name(), "OzeanAsset");
        assertEq(ozeanAssetL2.symbol(), "OZA");
        assertEq(ozeanAssetL2.bridge(), bridge);
        assertEq(ozeanAssetL2.remoteToken(), remoteToken);
    }

    function testSupportsInterface() public {
        // Test if the contract supports the IOptimismMintableERC20 and IERC165 interfaces
        assertTrue(ozeanAssetL2.supportsInterface(type(IOptimismMintableERC20).interfaceId));
        assertTrue(ozeanAssetL2.supportsInterface(type(IERC165).interfaceId));
    }

    function testMintByBridge() public {
        // Simulate the bridge minting tokens
        vm.prank(bridge);
        ozeanAssetL2.mint(user, MINT_AMOUNT);

        // Check if the user's balance is updated
        assertEq(ozeanAssetL2.balanceOf(user), MINT_AMOUNT);
    }

    function testMintByNonBridgeReverts() public {
        // Simulate a non-bridge caller attempting to mint tokens
        vm.expectRevert("MyTokenL2: caller is not the L2 bridge");
        ozeanAssetL2.mint(user, MINT_AMOUNT);
    }

    function testBurnByBridge() public {
        // Simulate the bridge minting tokens first
        vm.prank(bridge);
        ozeanAssetL2.mint(user, MINT_AMOUNT);

        // Simulate the bridge burning tokens
        vm.prank(bridge);
        ozeanAssetL2.burn(user, MINT_AMOUNT);

        // Check if the user's balance is updated
        assertEq(ozeanAssetL2.balanceOf(user), 0);
    }

    function testBurnByNonBridgeReverts() public {
        // Simulate a non-bridge caller attempting to burn tokens
        vm.expectRevert("MyTokenL2: caller is not the L2 bridge");
        ozeanAssetL2.burn(user, MINT_AMOUNT);
    }
}
