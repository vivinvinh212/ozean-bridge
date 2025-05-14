// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {L1Token} from "../src/tokens/L1Token.sol";

contract L1TokenTest is Test {
    L1Token public token;
    address public owner;
    address public user1;
    address public user2;

    uint256 constant INITIAL_SUPPLY = 1_000_000 * 10**18;

    function setUp() public {
        owner = address(this);
        user1 = address(0x1);
        user2 = address(0x2);

        token = new L1Token(
            "Test Token",
            "TT",
            18,
            INITIAL_SUPPLY,
            owner
        );
    }

    function test_InitialState() public view {
        assertEq(token.name(), "Test Token");
        assertEq(token.symbol(), "TT");
        assertEq(token.decimals(), 18);
        assertEq(token.totalSupply(), INITIAL_SUPPLY);
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY);
        assertEq(token.owner(), owner);
    }

    function test_Transfer() public {
        uint256 amount = 100 * 10**18;
        token.transfer(user1, amount);
        
        assertEq(token.balanceOf(user1), amount);
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY - amount);
    }

    function test_Mint() public {
        uint256 mintAmount = 50 * 10**18;
        token.mint(user1, mintAmount);
        
        assertEq(token.balanceOf(user1), mintAmount);
        assertEq(token.totalSupply(), INITIAL_SUPPLY + mintAmount);
    }

    function test_MintRevertWhenNotOwner() public {
        vm.startPrank(user1);
        vm.expectRevert();
        token.mint(user2, 100);
        vm.stopPrank();
    }

    function test_Burn() public {
        uint256 burnAmount = 50 * 10**18;
        token.burn(burnAmount);
        
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY - burnAmount);
        assertEq(token.totalSupply(), INITIAL_SUPPLY - burnAmount);
    }

    function test_BurnRevertWhenInsufficientBalance() public {
        vm.startPrank(user1);
        vm.expectRevert();
        token.burn(100);
        vm.stopPrank();
    }

    function test_Approve() public {
        uint256 allowanceAmount = 200 * 10**18;
        token.approve(user1, allowanceAmount);
        
        assertEq(token.allowance(owner, user1), allowanceAmount);
    }

    function test_TransferFrom() public {
        uint256 amount = 100 * 10**18;
        token.approve(user1, amount);
        
        vm.startPrank(user1);
        token.transferFrom(owner, user2, amount);
        vm.stopPrank();
        
        assertEq(token.balanceOf(user2), amount);
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY - amount);
        assertEq(token.allowance(owner, user1), 0);
    }

    function test_TransferFromRevertWhenInsufficientAllowance() public {
        uint256 amount = 100 * 10**18;
        token.approve(user1, amount - 1);
        
        vm.startPrank(user1);
        vm.expectRevert();
        token.transferFrom(owner, user2, amount);
        vm.stopPrank();
    }
}