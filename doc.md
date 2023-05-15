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
