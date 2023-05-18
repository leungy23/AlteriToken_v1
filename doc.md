# documentation for Alteritoken.sol

## Functions

```solidity
function addPerson(
        address _Address,
        string memory _pName,
        bool _isPerson
    ) external {
        //enforce only verifier can add person
        if (vMapping[msg.sender].isVerifier != true) revert AlteriToken__notVerifier();
        // add person  to personList
        person memory newPerson = person(_pName, _isPerson);
        pMapping[_Address] = newPerson;
        pArray.push(newPerson);
    }
```

The 'addPerson' function is used to add a person to the contract. The function takes two arguments, the address of the person to be added and the name of the person to be added. The function will fail if the person is already added to the contract.

## usage of addPerson
  
  ```solidity
  addPerson(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, "John Doe", true);
  ```

```solidity
 function makeDonation(
        address to,
        uint256 amount
    ) public returns (bool success) {
        // Ensure the spender is a Treasurer
        if (msg.sender != treasurer) revert AlteriToken__notTreasurer();
        // Ensure to address is an authorised person
        if (pMapping[to].isPerson != true) revert AlteriToken__notAuthorised();
        // Transfer the tokens
        _transfer(msg.sender, to, amount);
        return true;
    }
```

The 'makeDonation' function is used to make a donation to a person. The function takes two arguments, the address of the person to be donated to and the amount of tokens to be donated. The function will fail if either the person is not authorised to receive donations or if the sender is not the Treasurer.

## usage of makeDonation
  
  ```solidity
  makeDonation(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 100);
  ```

```solidity 
