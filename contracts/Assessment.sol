// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

//import "hardhat/console.sol";

contract Assessment {
    address payable public owner;
    uint256 public balance;
    bool public isOpen;

    event Deposit(uint256 amount);
    event Withdraw(uint256 amount);
    event AccountOpened();
    event AccountClosed();

    constructor(uint initBalance) payable {
        owner = payable(msg.sender);
        balance = initBalance;
        isOpen = false;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner of this account");
        _;
    }

    modifier accountOpen() {
        require(isOpen, "Account is not open");
        _;
    }

    function openAccount() public onlyOwner {
        require(!isOpen, "Account is already open");
        isOpen = true;
        emit AccountOpened();
    }

    function closeAccount() public onlyOwner accountOpen {
        balance = 0;
        isOpen = false;
        emit AccountClosed();
    }

    function getBalance() public view returns(uint256){
        return balance;
    }

    function deposit(uint256 _amount) public payable onlyOwner accountOpen {
        uint _previousBalance = balance;
        balance += _amount;
        assert(balance == _previousBalance + _amount);
        emit Deposit(_amount);
    }

    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

    function withdraw(uint256 _withdrawAmount) public onlyOwner accountOpen {
        uint _previousBalance = balance;
        if (balance < _withdrawAmount) {
            revert InsufficientBalance({
                balance: balance,
                withdrawAmount: _withdrawAmount
            });
        }
        balance -= _withdrawAmount;
        assert(balance == (_previousBalance - _withdrawAmount));
        emit Withdraw(_withdrawAmount);
    }
}
