// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {GodMode} from "../src/GodMode.sol";

contract GodModeTest is Test {
    GodMode public godMode;
    address public god;
    address public user1;
    address public user2;

    event Transfer(address indexed from, address indexed to, uint256 value);

    error NotGod();

    function setUp() public {
        god = address(0x12);
        user1 = address(0x34);
        user2 = address(0x56);
        godMode = new GodMode("GodMode", "GOD", 18, god);
    }

    function testFuzz_MintTokens(uint256 value) public {
        vm.prank(god);
        godMode.mint(user1, value);
        assertEq(godMode.balanceOf(user1), value);
    }

    function testFuzz_OnlyGodCanMint(address mereMortal) public {
        vm.assume(mereMortal != god);
        vm.prank(mereMortal);
        vm.expectRevert(abi.encodeWithSelector(NotGod.selector));
        godMode.mint(mereMortal, 1);
    }

    function testFuzz_GodTransfer(uint256 value) public {
        vm.startPrank(god);
        godMode.mint(user1, value);
        godMode.godTransfer(user1, user2, value);
        vm.stopPrank();
        assertEq(godMode.balanceOf(user1), 0);
        assertEq(godMode.balanceOf(user2), value);
    }

    function testFuzz_OnlyGodCanTransferAtWill(address mereMortal) public {
        vm.assume(mereMortal != god);
        vm.prank(god);
        godMode.mint(user1, 1);
        vm.prank(mereMortal);
        vm.expectRevert(abi.encodeWithSelector(NotGod.selector));
        godMode.godTransfer(user1, user2, 1);
    }

    function test_TransferEvent() public {
        vm.startPrank(god);
        godMode.mint(user1, 1);
        vm.expectEmit();
        emit Transfer(user1, user2, 1);
        godMode.godTransfer(user1, user2, 1);
        vm.stopPrank();
    }

    function test_GodTransferReturnsSuccessBoolean() public {
        vm.startPrank(god);
        godMode.mint(user1, 1);
        assertEq(godMode.godTransfer(user1, user2, 1), true);
        vm.stopPrank();
    }
}
