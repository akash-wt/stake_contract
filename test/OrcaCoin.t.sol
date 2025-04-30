// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/OrcaCoin.sol";

contract OrcaCoinTest is Test {
    OrcaContract c;

    function setUp() public {
        c = new OrcaContract(address(this));
    }

    function testInitialSupply() public view {
        assert(c.totalSupply() == 0);
    }

    function testMintFail() public {
        vm.startPrank(0xfF1D73Ea47222386fE482BAadb1f3d5755ea55c9);
        vm.expectRevert();
        c.mint(0xfF1D73Ea47222386fE482BAadb1f3d5755ea55c9, 10);
    }

    function testMint() public {
        c.mint(0xfF1D73Ea47222386fE482BAadb1f3d5755ea55c9, 10);
        assert(c.balanceOf(0xfF1D73Ea47222386fE482BAadb1f3d5755ea55c9) == 10);
    }

    function testUpdateStakingContract() public {
        c.updateStakingContract(0xfF1D73Ea47222386fE482BAadb1f3d5755ea55c9);
        vm.startPrank(0xfF1D73Ea47222386fE482BAadb1f3d5755ea55c9);

        c.mint(0xfF1D73Ea47222386fE482BAadb1f3d5755ea55c9, 10);
        assertEq(c.balanceOf(0xfF1D73Ea47222386fE482BAadb1f3d5755ea55c9), 10);
    }
}
