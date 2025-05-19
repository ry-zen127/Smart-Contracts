// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24; 

contract SimpleStorage {
    //favourite number gets initialised to 0 if no value is given 
    
    uint256 myFavouriteNumber;

    //uint256[] listofFavouriteNummbers;
    struct Person{
        uint256 FavouriteNumber;
        string name;
    }

    // Person public Adom = Person(7, "Adom");
    
    //dynamic array
    Person[] public listofPeople;

    function store(uint256 _FavouriteNumber) public {
        myFavouriteNumber = _FavouriteNumber;

    }

    mapping(string => uint256 ) public nameToFavouriteNumber;

   function retrieve () public view returns (uint256){
    return myFavouriteNumber;
   }

    //this function adds more data to the listofPeople array
   function addPerson(string memory _name, uint256 _FavouriteNumber) public{
        listofPeople.push( Person(_FavouriteNumber, _name));
        nameToFavouriteNumber[_name] = _FavouriteNumber;
   }
}
