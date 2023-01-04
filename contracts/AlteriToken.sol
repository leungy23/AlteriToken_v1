// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// TODO implement ensure person(s), vendors and verifiers cannot be in eachothers list
// example could be like...  if ((pMapping[address].isPerson != false || mMapping[address].isMerchant != false) == true) revert blah

error notOwner();
error notVerifier();
error notMerchant();
error notAuthorised();

// add error not treasurer

contract AlteriToken {
    address public owner;

    // Make deployer the owner
    constructor() {
        owner = msg.sender;
    }

    struct person {
        string pName;
        bool isPerson;
    }
    struct verifier {
        string vName;
        bool isVerifier;
    }
    struct merchant {
        string mName;
        bool isMerchant;
    }

    //TODO add struct for tresurer

    // Mapping from user addresses to their balances
    mapping(address => uint256) public balances;

    // Mapping from user addresses to their roles
    mapping(address => verifier) public vMapping;
    mapping(address => person) public pMapping;
    mapping(address => merchant) public mMapping;

    // Create arrays for adding new entities
    verifier[] internal vArray;
    person[] internal pArray;
    merchant[] internal mArray;

    // Function to allow owner to add a verifier
    function addVerifier(
        string memory _vName,
        bool _isVerifier,
        address _Address
    ) external {
        //enforce only owner can add verifiers
        if (msg.sender != owner) revert notOwner();
        // add verifier
        verifier memory newVerifier = verifier(_vName, _isVerifier);
        vMapping[_Address] = newVerifier;
        vArray.push(newVerifier);
    }

    // Function to add a user to the personList
    function addPerson(
        address _Address,
        string memory _pName,
        bool _isPerson
    ) external {
        //enforce only verifier can add person
        if (vMapping[msg.sender].isVerifier != true) revert notVerifier();
        // add person  to personList
        person memory newPerson = person(_pName, _isPerson);
        pMapping[_Address] = newPerson;
        pArray.push(newPerson);
    }

    // Function to add a merchant to the merchantList
    function addMerchant(
        address _mAddress,
        string memory _mName,
        bool _isMerchant
    ) public {
        //enforce only verifier can add merchant
        if (vMapping[msg.sender].isVerifier != true) revert notVerifier();
        // add merchant
        merchant memory newMerchant = merchant(_mName, _isMerchant);
        mMapping[_mAddress] = newMerchant;
        mArray.push(newMerchant);
    }

    // TODO Balance checker for Person
    function getBalance(address ContractAddress) public view returns (uint) {
        return ContractAddress.balance;
    }

    // TODO Mint from treasurer to person

    //TODO create the token

    // TODO generic transfer function

    // Function to transfer tokens to a merchant
    function spendDonation(address to, uint256 amount) public payable {
        // Ensure the spender is an authorised Person
        if (pMapping[msg.sender].isPerson != true) revert notAuthorised();
        // Ensure to address is an authorised Merchant
        if (mMapping[to].isMerchant != true) revert notMerchant();
        // Ensure the sender has sufficient funds
        require(balances[msg.sender] >= amount, "Insufficient funds");
        // Transfer the tokens
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
    // TODO - BURN tokens from vendor to Treasury
}
