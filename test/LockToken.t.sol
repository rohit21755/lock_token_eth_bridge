// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/LockToken.sol";
import "src/Token.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LockTokenTest is Test {
    LockToken lockToken;
    Token token;

    function setUp() public {
        token = new Token();
        lockToken = new LockToken(address(token));
    }

    function testLockToken() public {
        token.mint(0xf449dEe07546d70367FbB923Cc1e58fFDB753cF2, 100);
        vm.startPrank(0xf449dEe07546d70367FbB923Cc1e58fFDB753cF2);
        token.approve(address(lockToken), 100);
        lockToken.deposit(token, 100);
        assertEq(token.balanceOf(address(lockToken)), 100);
        assertEq(token.balanceOf(0xf449dEe07546d70367FbB923Cc1e58fFDB753cF2), 0);
        assertEq(lockToken.pendingBalance(0xf449dEe07546d70367FbB923Cc1e58fFDB753cF2), 100);

        lockToken.withdraw(token, 100);
        assertEq(token.balanceOf(address(lockToken)), 0);
        assertEq(token.balanceOf(0xf449dEe07546d70367FbB923Cc1e58fFDB753cF2), 100);
    }
}