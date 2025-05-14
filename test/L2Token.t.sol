// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {OptimismMintableERC20} from "../src/tokens/L2Token.sol";

contract L2TokenTest is Test {
    OptimismMintableERC20 public token;
    address public bridge;
    address public remoteToken;
    address public user1;
    address public user2;

    function setUp() public {
        bridge = address(0x4200000000000000000000000000000000000010);
        remoteToken = address(0x123);
        user1 = address(0x1);
        user2 = address(0x2);

        token = new OptimismMintableERC20(
            bridge,
            remoteToken,
            "Bridged Test Token",
            "BTT",
            18
        );
    }

    function test_InitialState() public view {
        assertEq(token.name(), "Bridged Test Token");
        assertEq(token.symbol(), "BTT");
        assertEq(token.decimals(), 18);
        assertEq(token.totalSupply(), 0);
        assertEq(token.bridge(), bridge);
        assertEq(token.remoteToken(), remoteToken);
    }

    function test_MintAsBridge() public {
        uint256 amount = 100 * 10**18;
        
        vm.startPrank(bridge);
        token.mint(user1, amount);
        vm.stopPrank();
        
        assertEq(token.balanceOf(user1), amount);
        assertEq(token.totalSupply(), amount);
    }

    function test_MintRevertWhenNotBridge() public {
        vm.startPrank(user1);
        vm.expectRevert("OptimismMintableERC20: only bridge can mint");
        token.mint(user2, 100);
        vm.stopPrank();
    }

    function test_BurnAsBridge() public {
        uint256 amount = 100 * 10**18;
        
        // First mint some tokens
        vm.startPrank(bridge);
        token.mint(user1, amount);
        
        // Then burn them
        token.burn(user1, amount);
        vm.stopPrank();
        
        assertEq(token.balanceOf(user1), 0);
        assertEq(token.totalSupply(), 0);
    }

    function test_BurnRevertWhenNotBridge() public {
        vm.startPrank(user1);
        vm.expectRevert("OptimismMintableERC20: only bridge can burn");
        token.burn(user2, 100);
        vm.stopPrank();
    }

    function test_Transfer() public {
        uint256 amount = 100 * 10**18;
        
        // First mint some tokens
        vm.startPrank(bridge);
        token.mint(user1, amount);
        vm.stopPrank();
        
        // Then transfer them
        vm.startPrank(user1);
        token.transfer(user2, amount);
        vm.stopPrank();
        
        assertEq(token.balanceOf(user1), 0);
        assertEq(token.balanceOf(user2), amount);
    }

    function test_SupportsInterface() public view {
        // Test IOptimismMintableERC20 interface ID
        bytes4 mintableInterface = type(IOptimismMintableERC20).interfaceId;
        assertTrue(token.supportsInterface(mintableInterface));
        
        // Test IERC165 interface ID
        bytes4 erc165Interface = type(IERC165).interfaceId;
        assertTrue(token.supportsInterface(erc165Interface));
        
        // Test unsupported interface
        bytes4 randomInterface = bytes4(keccak256("random"));
        assertFalse(token.supportsInterface(randomInterface));
    }

    function test_Approve() public {
        uint256 allowanceAmount = 200 * 10**18;
        
        vm.startPrank(user1);
        token.approve(user2, allowanceAmount);
        vm.stopPrank();
        
        assertEq(token.allowance(user1, user2), allowanceAmount);
    }

    function test_TransferFrom() public {
        uint256 amount = 100 * 10**18;
        
        // First mint some tokens
        vm.startPrank(bridge);
        token.mint(user1, amount);
        vm.stopPrank();
        
        // Approve user2 to spend user1's tokens
        vm.startPrank(user1);
        token.approve(user2, amount);
        vm.stopPrank();
        
        // Transfer from user1 to address(this) using user2
        vm.startPrank(user2);
        token.transferFrom(user1, address(this), amount);
        vm.stopPrank();
        
        assertEq(token.balanceOf(user1), 0);
        assertEq(token.balanceOf(address(this)), amount);
        assertEq(token.allowance(user1, user2), 0);
    }
}

// Import the interface for testing
interface IOptimismMintableERC20 {
    function remoteToken() external view returns (address);
    function bridge() external view returns (address);
    function mint(address _to, uint256 _amount) external;
    function burn(address _from, uint256 _amount) external;
}

interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}