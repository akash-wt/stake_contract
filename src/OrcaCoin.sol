// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract OrcaContract is ERC20 {
    address stakingContract;
    address owner;

    constructor(address _stakingContract) ERC20("Orca", "ORC") {
        stakingContract = _stakingContract;
        owner = msg.sender;
    }

    function mint(address to, uint256 amount) public {
        require(msg.sender == stakingContract);
        _mint(to, amount);
    }

    function updateStakingContract(address _stakingAddress) public {
        require(msg.sender == owner);
        stakingContract = _stakingAddress;
    }
}
