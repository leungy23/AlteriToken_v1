// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// TODO work out how to ensure person(s), vendors and verifiers cannot be in eachothers list - some require function...  tbc. require(person =! vendorList[]);
// TODO create the TOKEN and ensure this contract only uses this specific token - quite tired so not sure if this is essential or completely missing the point.

contract AlteriToken {
    struct person {
        string firstName;
        string lastName;
        address personAddress;
    }

    struct verifier {
        string verifierName;
        address verifierAddress;
    }
    verifier[] public verifiers;

    struct vendor {
        string vendorName;
        address vendorAddress;
    }

    // Mapping from user addresses to their balances
    mapping(address => uint256) public balances;

    // Mapping from user addresses to their roles
    mapping(address => bool) public verifierList;
    mapping(address => bool) public personList;
    mapping(address => bool) public vendorList;

    // Address of the contract owner
    address public owner;
    // Address to which vendors can send tokens

    address public treasurerAddress;

    // Constructor to set the contract owner
    constructor() {
        owner = msg.sender;
    }

    // Function to add a verifier to the verifierList
    function addVerifier(string memory _verifier, address _vAddress) public {
        // Only the contract owner can add users to the verifierList
        require(msg.sender == owner, "Only the owner can add verifiers");

        // Add the user to the verifierList
        verifier memory Verifier = verifier({
            verifierName: _verifier,
            verifierAddress: _vAddress
        });
        verifiers.push(verifier);
    }

    // Function to remove a user from the verifierList
    function removeVerifier(address user) public {
        // Only the contract owner can remove users from the verifierList
        require(msg.sender == owner, "Only the owner can remove verifiers");

        // Remove the user from the verifierList
        verifierList[user] = false;
    }

    // Function to add a user to the personList
    function addPerson(address user) public {
        // Only users in the verifierList can add users to the personList
        require(verifierList[msg.sender], "Only verifiers can add people");

        // Add the user to the personList
        personList[user] = true;
    }

    // Function to remove a user from the personList
    function removePerson(address user) public {
        // Only users in the verifierList can remove users from the personList
        require(verifierList[msg.sender], "Only verifiers can remove people");

        // Remove the user from the personList
        personList[user] = false;
    }

    // Function to transfer tokens to a user in the vendorList
    function spend(address recipient, uint256 amount) public payable {
        // Only users in the recipientList can transfer tokens to users in the vendorList
        require(personList[msg.sender], "Only recipients can transfer tokens");

        // Ensure the recipient is in the vendorList
        require(vendorList[recipient], "Recipient must be in the vendorList");

        // Ensure the sender has sufficient funds
        require(
            balances[msg.sender] >= amount,
            "Sender does not have sufficient funds"
        );

        // Transfer the tokens
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
    }
}

// Function to allow a user in the vendorList to send
