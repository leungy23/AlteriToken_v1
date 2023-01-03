// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// TODO work out how to ensure person(s), vendors and verifiers cannot be in eachothers list - some require function...  tbc. require(person =! vendorList[]);

contract AlteriToken {
    //declare variables
    address public owner;

    //make deployer the owner
    constructor() {
        owner = msg.sender;
    }

    struct person {
        string pName;
        uint256 pID;
    }

    struct verifier {
        string vName;
        uint256 vID;
    }

    struct merchant {
        string mName;
        uint256 mID;
    }

    // Mapping from user addresses to their balances
    mapping(address => uint256) public balances;

    // Mapping from user addresses to their roles
    mapping(address => verifier[]) public verifierList;
    mapping(address => person[]) public personList;
    mapping(address => merchant[]) public merchantList;

    // Function to allow owner to add a verifier
    function addVerifier(
        address _address,
        string memory _vName,
        uint256 _vID
    ) public {
        //enforce only owner can add verifiers
        require(msg.sender == owner, "Only owner can add a new verifier.");
        // add verifier to verifierList
        verifierList[_address].push(verifier(_vName, _vID));
    }

    // TODO new method required based on ne array, mapping structs
    // Function to remove a verifier from the verifierList
    //function removeVerifier(address _vAddress) public {
        //enforce only owner can remove verifiers
    //    require(msg.sender == owner, "Only owner can remove a verifier.");
        // Remove the user from the verifierList
    //    delete verifierList[_vAddress];
    //}

    // Function to add a user to the personList
    function addPerson(
        address _address,
        string memory _pName,
        uint256 _pID
    ) public {
        //enforce only owner can add person
        require(
            verifierList[msg.sender] == true,
            "Only authorised Verifiers can add a Person"
        );
        // add person  to personList
        personList[_address].push(person(_pName, _pID));
    }
    // TODO: Function to remove a user from the personList

    // Function to add a merchant to the merchantList
    function addMerchant(
        address _address,
        string memory _mName,
        uint256 _mID
    ) public {
        //enforce only owner can add person
        require(
            verifierList[msg.sender] == true,
            "Only authorised Verifiers can add a new Merchant"
        );        
        // add person  to personList
        merchantList[_address].push(merchant(_mName, _mID));
    }
    // TODO: Function to remove a user from the personList


    // Function to transfer tokens to a merchant
    function spendDonation(address to, uint256 amount) public payable {
        // Ensure the merchant is in the merchantList
        require(
            merchantList[to] == true,
            "Recipient must be an authorised Merchant"
        );
        // Ensure the sender has sufficient funds
        require(balances[msg.sender] >= amount, "Insufficient funds");
        // Transfer the tokens
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }

    // Address to which merchants can send tokens - live versions of Alteri tokens needs a neutral treasury party to manage funds for the donors/vendors
    // address public treasurerAddress;

    // TODO - Widthdraw tokens from vendor to treasury
    // function widthdraw(
    //     address owner,
    //     uint256 amount
    // ) public payable onlyVendor {
    //     // Transfer the tokens
    //     require(
    //         balances[msg.sender] >= amount,
    //         "Sender does not have sufficient funds"
    //     );
    //     balances[msg.sender] -= amount;
    //     balances[owner] += amount;
    // }
}
