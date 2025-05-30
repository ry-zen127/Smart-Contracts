// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter{
    
   // function withdraw() public{}
    function getPrice() internal view returns(uint256) {

    //address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
    //ABI; 
    AggregatorV3Interface pricefeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    //we are basically saying that we've created pricefeed and it is equal to the smart contract in that address and both of them are
    //in the form of AggregatorV3Interface
    (,int256 price,,,) = pricefeed.latestRoundData();
    //price feed is just a container and latestRoundData is asking something from pricefeed
   
    return uint256(price * 1e10);
    // price of ETH in terms of USD

    }

    function getConversionRate(uint256 ethAmount) internal view returns (uint256) {
       //ethAmount will be provided in the output so that the calculation can be computed
       //msg.value is essentially equal to ethAmount
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        // we are dividing by 1e18 because there are no decimals in solidity all of them appear as whole numbers and dividing them will result in a large number
        return ethAmountInUsd;

    }

    function getVersion() internal view returns (uint256){
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }

  
}