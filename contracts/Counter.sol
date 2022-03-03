// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Counter {
    uint256 counter;

    event CounterInc(address indexed addr, uint256 counter);

    function count() public {
        counter++;
        console.log("Counter is now", counter);
        emit CounterInc(msg.sender, counter);
    }

    function getCounter() public view returns (uint256) {
        return counter;
    }
}
