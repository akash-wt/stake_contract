// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StakingContract {
    mapping(address => uint) balances;
    mapping(address => uint) unclaimedRewards;
    mapping(address => uint) lastUpdatedTime;

    function stake() public payable {
        require(msg.value > 0);
        if (lastUpdatedTime[msg.sender]==0) {
            lastUpdatedTime[msg.sender] = block.timestamp;
        } else {
            unclaimedRewards[msg.sender] +=
                (block.timestamp - lastUpdatedTime[msg.sender]) *
                balances[msg.sender];
            lastUpdatedTime[msg.sender] = block.timestamp;
        }

        balances[msg.sender] += msg.value;
    }

    function unstake(uint _amount) public {
        require(_amount <= balances[msg.sender]);

        unclaimedRewards[msg.sender] +=
            (block.timestamp - lastUpdatedTime[msg.sender]) *
            balances[msg.sender];
        lastUpdatedTime[msg.sender] = block.timestamp;

        payable(msg.sender).transfer(_amount);
        balances[msg.sender] -= _amount;
    }

    function getRewards(address _address) public view  returns (uint){
        uint currentReward = unclaimedRewards[msg.sender];
        uint updateTime = lastUpdatedTime[msg.sender];
        uint newReward = (block.timestamp - updateTime) * balances[_address];

        return currentReward + newReward;
    }

    function claimRewards() public {
        uint currentReward = unclaimedRewards[msg.sender];
        uint updateTime = lastUpdatedTime[msg.sender];
        uint newReward = (block.timestamp - updateTime) * balances[msg.sender];

        // transfer currentReward + newReward unclaimedRewards[msg.sender ORCA tokens

        unclaimedRewards[msg.sender] = 0;
        lastUpdatedTime[msg.sender] = block.timestamp;
    }

    function balanceOf(address _address) public view returns (uint) {
        return balances[_address];
    }
 



}
