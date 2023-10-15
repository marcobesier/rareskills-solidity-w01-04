// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ERC20} from "solmate/tokens/ERC20.sol";

/**
 * @title GodMode
 * @author Marco Besier
 * @notice This contract implements an ERC-20 token that allows a special address (aka "god") to transfer
 * tokens at will.
 */
contract GodMode is ERC20 {
    address public immutable GOD;

    error NotGod();

    modifier onlyGod() {
        if (msg.sender != GOD) {
            revert NotGod();
        }
        _;
    }

    constructor(string memory name, string memory symbol, uint8 decimals, address god) ERC20(name, symbol, decimals) {
        GOD = god;
    }

    /**
     * @notice Allows GOD to transfer tokens at will.
     * @param recipient The address to transfer tokens to.
     * @param amount The amount of tokens to transfer.
     */
    function godTransfer(address from, address to, uint256 amount) external onlyGod returns (bool) {
        balanceOf[from] -= amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(from, to, amount);

        return true;
    }
}
