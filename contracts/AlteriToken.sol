// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// TODO work out how to ensure person(s), vendors and verifiers cannot be in eachothers list - some require function...  tbc. require(person =! vendorList[]);

error notOwner();
error notVerifier();
error notMerchant();

contract AlteriToken {
    //declare variables
    address public owner;

    //make deployer the owner
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

    // Mapping from user addresses to their balances
    mapping(address => uint256) public balances;

    // Mapping from user addresses to their roles
    mapping(address => verifier) public vMapping;
    mapping(address => person) public pMapping;
    mapping(address => merchant) public mMapping;

    verifier[] public vArray;
    person[] public pArray;
    merchant[] public mArray;

    verifier public Verifier;
    person public Person;
    merchant public Merchant;

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

    // TODO: Function to remove a verifier from the verifierList

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

    // TODO: Function to remove a user from the personList

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

    // TODO: Function to remove a user from the personList

    // Function to transfer tokens to a merchant
    function spendDonation(address to, uint256 amount) public payable {
        // Ensure the merchant is in the merchantList
        if (mMapping[msg.sender].isMerchant != true) revert notMerchant();
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
