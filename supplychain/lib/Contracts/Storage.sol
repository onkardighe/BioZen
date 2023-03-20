// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Storage {

    uint256 numberOfSupplies = 0;
    struct Supply {
        uint256 id;
        string name;
        uint256 quantity;
        uint256 temperature;
        address owner;
        string createdAt;

        bool initiated;
        bool isBuyerAdded;
        bool isTransporterAdded;
        bool isInsuranceAdded;
        bool isCompleted;
    }

    mapping(uint256 => Supply) public supplies;
    mapping(uint256 => address) public buyerList;
    mapping(uint256 => address) public transporterList;
    mapping(uint256 => address) public insuranceList;

    mapping(address => uint256[]) public subscriptionSupplyList;

    // --------------------------------------------------------------------------------------------------- //
    // -------------------------------------------- Modifiers -------------------------------------------- //
    // --------------------------------------------------------------------------------------------------- //
    modifier onlyIfTransporterAdded(uint256 id) {
      require(supplies[id].isTransporterAdded, "Error : Transporter is NOT added !!");
      _;
   }

   modifier onlyIfBuyerAdded(uint256 id) {
      require(supplies[id].isBuyerAdded, "Error : Buyer is NOT added !!");
      _;
   }

   modifier onlyIfInsuranceAdded(uint256 id) {
      require(supplies[id].isInsuranceAdded, "Error : Insurance is NOT added !!");
      _;
   }

    // --------------------------------------------------------------------------------------------------- //
    // -------------------------------------------- Functions -------------------------------------------- //
    // --------------------------------------------------------------------------------------------------- //
    function addSupply(string memory _name, uint256 _quantity, uint256 _temp, address supplierAddress, string memory _createdAt) public {
        supplies[numberOfSupplies] = Supply(numberOfSupplies, _name, _quantity, _temp, supplierAddress, _createdAt,true, false,false, false, false);
        subscriptionSupplyList[msg.sender].push(numberOfSupplies);
        numberOfSupplies++;
    }

    // Function to get single supply
    function getSupply(uint256 _id) public view returns (Supply memory) {
        return supplies[_id];
    }

    // Function to get all supplies
    function getSupplies() public view returns (Supply[] memory) {
        Supply[] memory _supplies = new Supply[](numberOfSupplies);
        for (uint256 i = 0; i < numberOfSupplies; i++) {
            _supplies[i] = supplies[i];
        }
        return _supplies;
    }

    // Get total number of supplies
    function totalSupplies() public view returns (uint256) {
        return numberOfSupplies;
    }

    // function to get Total number of Users
    function totalUsers(address add)public view returns (uint256) {
        return subscriptionSupplyList[add].length;
    }

     // function to get Total number of Users
    function getSuppliesOfUser(address userAddress)public view returns (uint256[] memory) {
        return subscriptionSupplyList[userAddress];
    }


    function addBuyer(uint256 id,  address _buyerAddress) public
    {
        supplies[id].isBuyerAdded = true;
        buyerList[id] = _buyerAddress;
        subscriptionSupplyList[_buyerAddress].push(id);
    }

    function addTransporter(uint256 id,  address _transporterAddress) public onlyIfBuyerAdded(id) 
    {
        supplies[id].isTransporterAdded = true;
        transporterList[id] = _transporterAddress;
        subscriptionSupplyList[_transporterAddress].push(id);
    }

    function addInsurance(uint256 id,  address _insuranceAddress) public onlyIfBuyerAdded(id) 
    {
        supplies[id].isInsuranceAdded = true;
        insuranceList[id] = _insuranceAddress;
        subscriptionSupplyList[_insuranceAddress].push(id);
    }


    function getTransporter(uint256 id) public view onlyIfTransporterAdded(id) returns(address)
    {
        return transporterList[id];
    }

    function getBuyer(uint256 id) public view onlyIfBuyerAdded(id) returns(address)
    {
        return buyerList[id];
    }

    function getInsurance(uint256 id) public view onlyIfInsuranceAdded(id) returns(address)
    {
        return insuranceList[id];
    }    
}