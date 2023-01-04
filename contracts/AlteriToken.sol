// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// TODO implement ensure person(s), vendors and verifiers cannot be in eachothers list
// example could be like...  if ((pMapping[address].isPerson != false || mMapping[address].isMerchant != false) == true) revert blah

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

    // TODO Balance checker for Person
    function getBalance(address ContractAddress) public view returns (uint) {
        return ContractAddress.balance;
    }

    // TODO Mint from treasurer to person

    // TODO create the token

    // generic transfer rules
    function transfer(address _from, address _to, uint _amount) internal {
        if (bMap[_from] >= _amount) revert transferError2();
        if (bMap[_to] + _amount <= bMap[_to]) revert transferError3();
        bMap[_from] -= _amount;
        bMap[_to] += _amount;
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
    function makeDonation(
        address to,
        uint256 amount
    ) public returns (bool success) {
        // Ensure the spender is an authorised Person
        if (msg.sender != treasurer) revert notTreasurer();
        // Ensure to address is an authorised Merchant
        if (pMapping[to].isPerson != true) revert notAuthorised();
        // Transfer the tokens
        _transfer(msg.sender, to, amount);
        return true;
    }

    function increaseAllowance(
        address,
        uint256
    ) public virtual override returns (bool) {
        return false;
    }

    function approve(address, uint256) public virtual override returns (bool) {
        return false;
    }

    function decreaseAllowance(
        address,
        uint256
    ) public virtual override returns (bool) {
        return false;
    }
} // TODO - BURN tokens from vendor to treasurer
