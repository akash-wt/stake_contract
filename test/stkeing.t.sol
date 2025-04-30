// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/stakingContract.sol";

contract OrcaCoinTest is Test {
    StakingContract c;

    function setUp() public {
        c = new StakingContract();
    }

    function  testStake() public {
        c.stake{value:200}();
        assertEq(c.balanceOf(address(this)), 200);
        
    }

    function testStakeUser() public{
        vm.startPrank(0xfF1D73Ea47222386fE482BAadb1f3d5755ea55c9);
        vm.deal(0xfF1D73Ea47222386fE482BAadb1f3d5755ea55c9, 10 ether);
        c.stake{value: 1 ether}();
        assertEq(c.balanceOf(0xfF1D73Ea47222386fE482BAadb1f3d5755ea55c9), 1 ether);
    }

    function  testUnstake() public {
        c.stake{value: 200 }();
        c.unstake(100);
        assertEq(c.balanceOf(address(this)), 100);
        
    }

    function testUnstakeFail() public{
        c.stake{value:200}();
        vm.expectRevert();
        c.unstake(300);
    }
}
