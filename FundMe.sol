//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";
//	gas 944516  transact 821318
// gas 921799  transact 801564 when constant is added

error NotOwner();

contract FundMe{

   address public immutable i_owner;

    constructor() {
      i_owner = msg.sender;
    }
    

    using PriceConverter for uint256;
    
    uint256 public constant MINIMUM_USD = 5e18;
    //5e18 = 5 * 10^18

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    function fund() public payable{
       require(msg.value.getConversionRate() >= MINIMUM_USD, "didnt send enough ETH");
        //msg.value.getConversionRate() is converting the amount that the address has sent from eth to Usd
        //msg.value is essentially equal to ethAmount
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    }

      function withdraw() public onlyOwner{
      
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
        //funderIndex++ => funderIndex = funderIndex + 1
        address funder = funders[funderIndex];
        addressToAmountFunded[funder] = 0;
      }
      //the for loop iterates through all funders who have contributed to the 
      //contract and resets their funded amounts to 0

      funders = new address[](0);
      //this resets the funders array


//there are 3 ways of sending ETH from a contract
// //1. (.transfer) //if it fails it throws an error

//     //msg.sender is of type address
//     //payable(msg.sender) is of type payable address
//     payable(msg.sender).transfer(address(this).balance);
//     //the line of code above transfers all the funds (balance) in this contract
//     //to the one who calls it (msg.sender)


// //2. (.send) // if it fails it throws a bool
//     bool sendSuccess = payable (msg.sender).send(address(this).balance);
//     require(sendSuccess, "Send failed");
//     //for send if there is an error it returns a boolean which is "send failed" p.s we created it
//     // but if it is true it calls or executes sendSuccess

//3. (.call) //if it fails it throws a bool
    (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
    require (callSuccess, "Call failed");

    //  {bool callSuccess, bytes memory dateReturned} = payable(msg.sender).call{value: address(this).balance}("");
    // require (callSuccess, "Call failed");
    }

  modifier onlyOwner(){
    //require (msg.sender == i_owner, "Sender is not owner");
    if(msg.sender != i_owner) {revert NotOwner();} //more gas efficient
    _;
  }

  receive() external payable{
    fund();
  }

  fallback() external payable{
    fund();
  }

  // What happens if someone sends this Contract ETH without calling fund();
}



