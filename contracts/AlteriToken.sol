// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

error notTreasurer();
error notVerifier();
error notMerchant();
error notAuthorised();
error transferError1();
error transferError2();
error transferError3();

contract AlteriToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("AlteriToken", "ATK") {
        _mint(msg.sender, initialSupply);
        treasurer = msg.sender;
    }

    address public treasurer;

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
    mapping(address => uint256) public bMap;

    // Mapping from user addresses to their roles
    mapping(address => verifier) public vMapping;
    mapping(address => person) public pMapping;
    mapping(address => merchant) public mMapping;

    // Create arrays for adding new entities
    verifier[] internal vArray;
    person[] internal pArray;
    merchant[] internal mArray;

    // TODO implement ensure person(s), vendors and verifiers cannot be in eachothers list
    // example could be like...  if ((pMapping[address].isPerson != false || mMapping[address].isMerchant != false) == true) revert blah

    // Function to allow Treasurer to add a verifier
    function addVerifier(
        string memory _vName,
        bool _isVerifier,
        address _Address
    ) external {
        //enforce only Treasurer can add verifiers
        if (msg.sender != treasurer) revert notTreasurer();
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

    // Function to transfer tokens to a merchant
    function makeDonation(
        address to,
        uint256 amount
    ) public returns (bool success) {
        // Ensure the spender is a Treasurer
        if (msg.sender != treasurer) revert notTreasurer();
        // Ensure to address is an authorised person
        if (pMapping[to].isPerson != true) revert notAuthorised();
        // Transfer the tokens
        _transfer(msg.sender, to, amount);
        return true;
    }

    // Function to transfer tokens to a merchant
    function spendDonation(
        address to,
        uint256 amount
    ) public returns (bool success) {
        // Ensure the spender is an authorised Person
        if (pMapping[msg.sender].isPerson != true) revert notAuthorised();
        // Ensure to address is an authorised Merchant
        if (mMapping[to].isMerchant != true) revert notMerchant();
        // Transfer the tokens
        _transfer(msg.sender, to, amount);
        return true;
    }

    // Function to transfer tokens to a merchant
    function redeemTokens(
        address to,
        uint256 amount
    ) public returns (bool success) {
        // Ensure the redeemer is a Merchant
        if (mMapping[msg.sender].isMerchant != true) revert notMerchant();
        // Ensure to address is the treasurer
        if (msg.sender != treasurer) revert notTreasurer();
        // Transfer the tokens
        _transfer(msg.sender, to, amount);
        return true;
    }

    function increaseAllowance(
        address,
        uint256
    ) public virtual override returns (bool) {
        revert notAuthorised();
    }

    function approve(address, uint256) public virtual override returns (bool) {
        revert notAuthorised();
    }

    function decreaseAllowance(
        address,
        uint256
    ) public virtual override returns (bool) {
        revert notAuthorised();
    }

    function transfer(address, uint256) public virtual override returns (bool) {
        revert notAuthorised();
    }

    function transferFrom(
        address,
        address,
        uint256
    ) public virtual override returns (bool) {
        revert notAuthorised();
    }
}

//// ACTORS

//  A.  0x5B3...eddC4   <- treasurer (contract deployer)
//  B.  0xAb84...35cb2  <- verifier (created by treasurer)
//  C.  0x4B2...C02db   <- person (created by verifier)
//  D.  0x787...cabaB   <- merchant: (created by verifier)

//// FLOW

//  1 - deploy contact with 1000 tokens
//  2 - treasurer creates verifiers
//  3 - verifier creates person
//  4 - verifier creates merchant
//  5 - treasurer donates tokens to person - TODO 'real donor' => person
//  6 - person spends donation at merchant
//  7 - merchant redeems fiat

//// NEXT STEPS

// 1 - For altiertoken.sol, write test scripts and optimise gas, peer review/audit

// 2 - Mobile dApp built (figma's started)
// 3 - Partner with NGO who can act as treasurer
// 4 - Partner charity / merchants
// 5 - Marketing required to get sign ups
// 6 - DiD for orgs

//// CHALLENGES

// 1 - Programmable CBDCs
// 2 - Finding the right partners
