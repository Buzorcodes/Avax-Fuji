// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract DegenToken {
    address public  owner;
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;

    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor() {
        owner = msg.sender;
        name = "Degen";
        symbol = "DGN";
        decimals = 18;
    }

    modifier OnlyOwner() {
        require(msg.sender == owner, "Only Owner");
        _;
    }

    modifier IsNonZero(uint value) {
        require(value > 0, "Value cannot be zero");
        _;
    }


    function mint( uint256 _value) public OnlyOwner IsNonZero(_value) returns (bool success) {
        balanceOf[msg.sender] += _value;
        totalSupply += _value;
        return true;
    }

        function burn(uint256 _value) public IsNonZero(_value)  returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient fund");
        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;
        return true;
    }

        function transfer(address _to, uint256 _value) public IsNonZero(_value)  returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient fund");

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

}
