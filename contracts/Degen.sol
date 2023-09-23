// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract DegenToken {
    address public owner;
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => uint256) public prizes; // Mapping to store prize selections and their costs

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Redeem(address indexed user, uint256 prizeCost, string prize);

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

    modifier IsNonZero(uint256 value) {
        require(value > 0, "Value cannot be zero");
        _;
    }

    // Function to mint tokens
    function mint(uint256 _value) public OnlyOwner IsNonZero(_value) returns (bool success) {
        balanceOf[msg.sender] += _value;
        totalSupply += _value;
        return true;
    }

    // Function to burn tokens
    function burn(uint256 _value) public IsNonZero(_value) returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient funds");
        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;
        return true;
    }

    // Function to transfer tokens to another address
    function transfer(address _to, uint256 _value) public IsNonZero(_value) returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient funds");

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    // Function to redeem a prize
    function redeem(string memory _prize, uint256 _cost) public IsNonZero(_cost) returns (bool success) {
        require(balanceOf[msg.sender] >= _cost, "low funds");

        // Deduct the cost of the prize from the user's balance
        balanceOf[msg.sender] -= _cost;

        // Record the user's prize selection
        prizes[msg.sender] = _cost;

        emit Redeem(msg.sender, _cost, _prize);

        return true;
    }
}
