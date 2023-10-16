// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ERC20} from "solmate/tokens/ERC20.sol";

/**
 * @title GodMode
 * @author Marco Besier
 * @notice This contract implements an ERC-20 token that allows a special address (aka "GOD") to mint and transfer
 * tokens at will.
 */
contract GodMode is ERC20 {
    address public immutable GOD;

    event GodTransfer(address indexed from, address indexed to, uint256 value);

    error NotGod();
    error GodMustNotBeZero();

    modifier onlyGod() {
        if (msg.sender != GOD) {
            revert NotGod();
        }
        _;
    }

    constructor(string memory name, string memory symbol, uint8 decimals, address god) ERC20(name, symbol, decimals) {
        if (god == address(0)) {
            revert GodMustNotBeZero();
        }
        GOD = god;
    }

    /**
     * @dev Mints new tokens and assigns them to the specified account. Only GOD is allowed to call this function.
     * Emits a {Transfer} event with `from` set to the zero address.
     * @param to The account that will receive the minted tokens.
     * @param value The amount of tokens to mint in units of the smallest denomination.
     */
    function mint(address to, uint256 value) external onlyGod {
        _mint(to, value);
    }

    /**
     * @notice Allows GOD to transfer tokens at will.
     * @param from The address to transfer tokens from.
     * @param to The address to transfer tokens to.
     * @param value The amount of tokens to transfer in units of the smallest denomination.
     * @return True if the transfer succeeds.
     */
    function godTransfer(address from, address to, uint256 value) external onlyGod returns (bool) {
        balanceOf[from] -= value;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += value;
        }

        emit GodTransfer(from, to, value);

        return true;
    }
}
