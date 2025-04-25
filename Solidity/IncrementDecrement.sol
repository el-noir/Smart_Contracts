// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;

contract IncrementDecrement {
    uint256 counter;

    event Increment(string message);
    event Decrement(string message);

    function IncrementFunc() public {
        counter++;
        emit Increment("Value incremented by 1");
    }

    function DecrementFunc() public {
        counter--;
        emit Decrement("Value decremented by 1");
    }

    function reset() public {
        counter = 0;
    }

    function getValue() public view returns (uint256) {
        return counter;
    }
}
