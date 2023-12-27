// SPDX-License-Identifier: BSD-2-Clause
pragma solidity ^0.8.22;

contract BillingAccount {
    mapping(address => uint) public balance;

    function deposit() public payable {
        balance[msg.sender] += msg.value;
    }

    receive() external payable {
        balance[msg.sender] += msg.value;
    }

    fallback() external payable {
        balance[msg.sender] += msg.value;
    }

    function withdraw(uint amount) public {
        balance[msg.sender] -= amount;
        (bool ok, ) = msg.sender.call{value: amount}("");
        require(ok, "Failed to send Ether");
    }

    mapping(address => bool) public owners;

    constructor() {
        owners[msg.sender] = true;
    }

    modifier privileged() {
        require(owners[msg.sender], "Privileged function");
        _;
    }

    function charge(address user, uint amount) public privileged {
        balance[user] -= amount;
        (bool ok, ) = msg.sender.call{value: amount}("");
        require(ok, "Failed to send Ether");
    }

    function addOwner(address owner) public privileged {
        owners[owner] = true;
    }

    function removeOwner(address owner) public privileged {
        delete owners[owner];
    }
}
