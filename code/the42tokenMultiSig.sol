// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract The42TokenMultiSig {
    
    address[] public owners;
    uint public signaturesRequired;

    struct Transaction{
        address to;
        uint value;
        bool executed;
    }
    
    mapping(uint => mapping(address => bool)) public isConfirmed;
    Transaction[] public transactions;

    constructor(address[] memory _owners, uint _signaturesRequired) {
        require(_owners.length > 0, "No Owners !!");
        require(_signaturesRequired > 0 && signaturesRequired <= _owners.length, "Need to be Confirmed");
        
        for (uint i = 0; i < _owners.length; i++){
            require(_owners[i] != address(0),"Owner is Invalid");
            owners.push(_owners[i]);
        }
        signaturesRequired = _signaturesRequired;
    }

    function submitTransaction(address _to) public payable {
        require(_to!=address(0),"Receiver address is Invalid");
        require(msg.value>0,"Transfer amount must be greater than zero.");
        uint transactionId = transactions.length;
        transactions.push(Transaction{_to,msg.value,false});

    }
}
