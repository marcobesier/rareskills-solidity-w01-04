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

    function testFuzz_GodTransfer(uint256 value) public {
        vm.prank(god);
        godMode.godTransfer(user1, user2, value);
        assertEq(godMode.balanceOf(user1), 0);
    }
}
