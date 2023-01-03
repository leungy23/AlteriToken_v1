// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// TODO work out how to ensure person(s), vendors and verifiers cannot be in eachothers list - some require function...  tbc. require(person =! vendorList[]);

contract AlteriToken {
    error custError();

    //declare variables
    address public owner;

    //make deployer the owner
    constructor() {
        owner = msg.sender;
    }

    struct person {
        string pName;
        address pAddress;
    }

    struct verifier {
        string vName;
        address vAddress;
    }

    struct merchant {
        string mName;
        address mAddress;
    }

    // Mapping from user addresses to their balances
    mapping(address => uint256) public balances;

    // Mapping from user addresses to their roles
    mapping(uint256 => verifier) public vMapping;
    mapping(uint256 => person) public pMapping;
    mapping(uint256 => merchant) public mMapping;

    verifier[] internal vArray;
    person[] internal pArray;
    merchant[] internal mArray;

    verifier public Verifier;
    person public Person;
    merchant public Merchant;

    // Function to allow owner to add a verifier
    function addVerifier(
        address _vAddress,
        string memory _vName,
        uint256 _vID
    ) external {
        //enforce only owner can add verifiers
        if (msg.sender != owner) revert custError();
        // add verifier
        verifier memory newVerifier = verifier(_vName, _vAddress);
        vMapping[_vID] = newVerifier;
        vArray.push(newVerifier);
    }

    // TODO: Function to remove a verifier from the verifierList

    // Function to add a user to the personList
    function addPerson(
        address _pAddress,
        string memory _pName,
        uint256 _pID
    ) external {
        //enforce only verifier can add person
        if (msg.sender != Verifier.vAddress) revert custError();
        // add person  to personList
        person memory newPerson = person(_pName, _pAddress);
        pMapping[_pID] = newPerson;
        pArray.push(newPerson);
    }

    // TODO: Function to remove a user from the personList

    // Function to add a merchant to the merchantList
    function addMerchant(
        address _mAddress,
        string memory _mName,
        uint256 _mID
    ) public {
        //enforce only verifier can add merchant
        if (msg.sender != Verifier.vAddress) revert custError();
        // add merchant
        merchant memory newMerchant = merchant(_mName, _mAddress);
        mMapping[_mID] = newMerchant;
        mArray.push(newMerchant);
    }

    // TODO: Function to remove a user from the personList

    // Function to transfer tokens to a merchant
    function spendDonation(address to, uint256 amount) public payable {
        // Ensure the merchant is in the merchantList
        if (msg.sender != Merchant.mAddress) revert custError();
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
