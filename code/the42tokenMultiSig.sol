// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract The42TokenMultiSig is ERC20 {
    
    // ========== TOKEN CONFIGURATION ==========
    uint256 public constant INIT_SUPP = 1337 * 10**18;          // Initial supply: 1337 tokens (18 decimals)

    // ========== MULTISIG VARIABLES ==========
    address[] public owners;
    uint public signaturesRequired;

    // Transaction structure for pending transfers
    struct Transaction{
        address to;
        uint value;
        bool executed;
    }
    
    // Mapping to track which owners confirmed which transactions
    mapping(uint => mapping(address => bool)) public isConfirmed;
    Transaction[] public transactions;

    // ========== EVENTS ==========
    event TransactionSubmitted(uint transactionId, address sender, address receiver, uint amount);
    event TransactionConfirmed(uint transactionId);
    event TransactionExecuted(uint transactionId);
    
    // ========== CONSTRUCTOR ==========
    /**
     * @dev Initializes the token and multisig system.
     * @param _owners List of addresses who can approve transfers.
     * @param _signaturesRequired Minimum confirmations needed to execute a transfer.
     */
    constructor(address[] memory _owners, uint _signaturesRequired) ERC20("The42Token", "F42") {
        require(_owners.length > 0, "No Owners !!");
        require(_signaturesRequired > 0 && signaturesRequired <= _owners.length, "Invalid confirmations requirement");
        // Set up owners
        for (uint i = 0; i < _owners.length; i++){
            require(_owners[i] != address(0),"Owner is Invalid");
            owners.push(_owners[i]);
        }
        signaturesRequired = _signaturesRequired;
        _mint(address(this), INIT_SUPP);        // Mint all tokens to the contract (not to an individual)
    }

    function submitTransaction(address _to) public payable {
        require(_to!=address(0),"Receiver address is Invalid");
        require(msg.value>0,"Transfer amount must be greater than zero.");
        uint transactionId = transactions.length;
        transactions.push(Transaction({to:_to,value:msg.value,executed:false}));
        emit TransactionSubmitted(transactionId, msg.sender, _to, msg.value);
    }

    function confirmTransaction(uint _transactionId) public {
        require(_transactionId<transactions.length, "Invalid Transaction Id");
        require(!isConfirmed[_transactionId][msg.sender],"Transaction already Confirmed");
        isConfirmed[_transactionId][msg.sender] = true;
        emit TransactionConfirmed(_transactionId);
        if(isTransactionConfirmed(_transactionId)) {
            executeTransaction(_transactionId);
        }
    }

    function isTransactionConfirmed(uint _transactionId) internal view returns(bool){
        require(_transactionId<transactions.length, "Invalid Transaction Id");
        uint confirmationCounter;
        for (uint i = 0;i < owners.length;i++){
            if(isConfirmed[_transactionId][owners[i]]){
                confirmationCounter ++;
            }
        }
        return confirmationCounter>=signaturesRequired;
    }

    function executeTransaction(uint _transactionId) internal {
        require(_transactionId<transactions.length, "Invalid Transaction Id");
        require(!transactions[_transactionId].executed,"Transaction already Executed");
        (bool success,)=transactions[_transactionId].to.call{value:transactions[_transactionId].value}("");
        require(success, "Invalid Transaction Execution Failed");
        transactions[_transactionId].executed=true;
        emit TransactionExecuted(_transactionId);
    }
}
