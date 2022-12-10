// SPDX-License-Identifier: None

pragma solidity ^0.8.7;

contract CrpyptoKids {

address owner;

constructor() {
    owner == msg.sender;
}

struct Kid {
    address payable wallet;
    string name;
    string lastName;
    uint releaseTime;
    uint amount;
    bool canWithdraw;
}
Kid[] public kids;

  //add kids to contract
function addKid(address payable wallet, string memory name, string memory lastName, uint releaseTime, uint amount, bool canWithdraw) public {
    kids.push(Kid(
        wallet,
        name,
        lastName,
        releaseTime,
        amount,
        canWithdraw
    ));
}


 //wallet balance public view
function walletBalance() public view returns(uint) {
     return address(this).balance;
}

 //add funds to contract, and speccifically to kid(s)
function deposit(address wallet) payable public {
    addToBalance(wallet) ;
    }


function addToBalance(address wallet) private{
    for(uint i = 0; i < kids.length; i++) {
        if(kids[i].wallet == wallet) {
          kids[i].amount += msg.value;
        }
    }
}

  /// do not like this 999 thing
function getIndex(address wallet) public view returns(uint) {
    for(uint i = 0; i < kids.length; i++) {
        if (kids[i].wallet == wallet) {
            return i;
        }
    }
    return 999;
}


  //kid checks if can withdraw (hate all these loops, not gas efficiet i will learn better methods)
 //not my contract would not use this time stamp method, vulnerable to hack from miners
function available(address wallet) public returns(bool) {
    uint i = getIndex(wallet);
    if (block.timestamp > kids[i].releaseTime) {
    kids[i].canWithdraw = true;
    return true;
    } else {
        return false;
    }
}


  //withdraw funds
function withdraw(address payable wallet) payable public {
    uint i = getIndex(wallet);
    kids[i].wallet.transfer(kids[i].amount);
}
}
