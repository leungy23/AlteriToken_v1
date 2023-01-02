// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

// TODO work out how to ensure person(s), vendors and verifiers cannot be in eachothers list - some require function...  tbc. require(person =! vendorList[]);

error notPerson();
error notVerifier();
error notVendor();

contract AlteriToken {
    // Set contract deployer as owner
    constructor() {
        owner = msg.sender;
    }

    // Structs for 3 actors
    struct person {
        string personName;
        address personAddress;
    }
    struct verifier {
        string verifierName;
        address verifierAddress;
    }
    struct vendor {
        string vendorName;
        address vendorAddress;
    }

    // Modifiers for 3 actors
    // Possible issue is using the struct - might need to use xAddress instead of the struct name
    modifier onlyOwner() {
        require(msg.sender == owner);
        if (msg.sender != owner) revert notOwner();
        _;
    }
    modifier onlyPerson() {
        require(msg.sender == person);
        if (msg.sender != person) revert notPerson();
        _;
    }
    modifier onlyVerifier() {
        require(msg.sender == verifier);
        if (msg.sender != verifier) revert notVerifier();
        _;
    }
    modifier onlyVendor() {
        require(msg.sender == vendor);
        if (msg.sender != vendor) revert notVendor();
        _;
    }

    // Mapping from user addresses to their balances
    mapping(address => uint256) public balances;

    // Mapping from user addresses to their roles
    mapping(address => bool) public verifierList;
    mapping(address => bool) public personList;
    mapping(address => bool) public vendorList;

    // Function to add a verifier to the verifierList
    function addVerifier(
        string memory _verifier,
        address _vAddress
    ) public onlyOwner {
        // Add the user to the verifierList
        verifier memory Verifier = verifier({
            verifierName: _verifier,
            verifierAddress: _vAddress
        });
        verifiers.push(verifier);
    }

    // Function to remove a user from the verifierList
    function removeVerifier(address user) public onlyOwner {
        // Remove the user from the verifierList
        verifierList[verifier] = false;
    }

    // Function to add a user to the personList
    function addPerson(address user) public onlyVerifier {
        // Add the user to the personList
        personList[user] = true;
    }

    // Function to remove a user from the personList
    function removePerson(address user) public onlyVerifier {
        // Remove the user from the personList
        personList[user] = false;
    }

    // Function to transfer tokens to a vendor
    function spendDonation(
        address vendor,
        uint256 amount
    ) public payable onlyPerson {
        // Ensure the vendor is in the vendorList
        require(vendorList[vendor], "Recipient must be in the vendorList");
        // Ensure the sender has sufficient funds
        require(
            balances[msg.sender] >= amount,
            "Sender does not have sufficient funds"
        );

        // Transfer the tokens
        balances[msg.sender] -= amount;
        balances[vendor] += amount;
    }

    // Address to which vendors can send tokens - live versions of Alteri tokens needs a neutral treasury party to manage funds for the donors/vendors
    // address public treasurerAddress;

    // TODO - Widthdraw tokens from vendor to treasury
    function widthdraw(
        address owner,
        uint256 amount
    ) public payable onlyVendor {}
}
