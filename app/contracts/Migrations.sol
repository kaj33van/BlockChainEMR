pragma solidity ^0.5.1;

//Contract to keep checks on Contracts on the network
/*
Storing owner in type address
Keep check on last completed Deployment or migrations of contract in integer
*/
contract Migrations {
  address public owner;
  uint public last_completed_migration;

  //Allowing access only to the owner of the contract
  modifier restricted() {
    if (msg.sender == owner) _;
  }

  //Setting current(or first) interacting address as owner
  constructor() public {
    owner = msg.sender;
  }

  //number of times migrations are done or contracts are executed
  function setCompleted(uint completed) public restricted {
    last_completed_migration = completed;
  }

  //Upgrading the migrations details to new address once the old migrations are set as completed
  function upgrade(address new_address) public restricted {
    Migrations upgraded = Migrations(new_address);
    upgraded.setCompleted(last_completed_migration);
  }
}

//Contract that performs destruction by contract owner 
contract  contractdestruction is Migrations{
    function deleteContract() public restricted{
            //destruction should be called by only owner
            require (msg.sender == owner);
            selfdestruct(msg.sender);
        }

}

