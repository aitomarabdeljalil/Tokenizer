// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title The42TokenMultiSig - An ERC20 token with multisignature (multisig) transfer control.
 * @dev This contract extends ERC20 and requires multiple approvals for token transfers.
 */

contract The42TokenMultiSig is ERC20 {
    // ========== MULTISIG VARIABLES ==========
    address[] public owners;
    uint256 public numConfirmationsRequired;
    mapping(address => bool) public isOwner;

    // Transaction structure for pending transfers
    struct Transaction {
        address target;
        uint256 amount;
        bool executed;
    }

    Transaction[] public transactions;
    // Mapping to track which owners confirmed which transactions
    mapping(uint256 => mapping(address => bool)) public approved;

    constructor(address[] memory _owners, uint256 _numConfirmationsRequired)
        ERC20("42token", "K42")
    {
        require(_owners.length > 0, "Owners required");
        require(
            _numConfirmationsRequired >= 1 &&
                _numConfirmationsRequired <= _owners.length,
            "Invalid number of required confirmations"
        );

        for (uint256 i = 0; i < _owners.length; i++) {
            address ownerAddress = _owners[i];
            require(
                ownerAddress != address(0),
                "Null address specified as an owner"
            );
            require(!isOwner[ownerAddress], "Owner not unique");
            isOwner[ownerAddress] = true;
            owners.push(ownerAddress);
        }

        numConfirmationsRequired = _numConfirmationsRequired;
        uint256 tokensPerOwner = 1337 * (10**18);
        for (uint256 i = 0; i < owners.length; i++) {
            _mint(owners[i], tokensPerOwner);
        }
    }

    // ========== EVENTS ==========
    event submitTransaction(uint256 indexed transactionId);
    event approveTransaction(address indexed owner, uint256 transactionId);
    event executeTransaction(uint256 indexed transactionId);
    event revokeTransaction(address indexed owner, uint256 transactionId);

    // ========== MODIFIERS ==========
    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not an owner");
        _;
    }

    modifier txExists(uint256 _txId) {
        require(_txId < transactions.length, "Transaction doesn't exist");
        _;
    }

    modifier notApproved(uint256 _txId) {
        require(!approved[_txId][msg.sender], "Already approved");
        _;
    }

    modifier notExecuted(uint256 _txId) {
        require(!transactions[_txId].executed, "Transaction already executed");
        _;
    }

    function submit(address _target, uint256 _amount) external onlyOwner {
        require(_target != address(0), "Invalid destination address");
        require(_amount > 0, "Amount must be greater than 0");
        transactions.push(
            Transaction({target: _target, amount: _amount, executed: false})
        );
        emit submitTransaction(transactions.length - 1);
    }

    function approve(uint256 _txId)
        external
        onlyOwner
        txExists(_txId)
        notApproved(_txId)
        notExecuted(_txId)
    {
        approved[_txId][msg.sender] = true;
        emit approveTransaction(msg.sender, _txId);
    }

    function _getApprovalCount(uint256 _txId)
        public
        view
        returns (uint256 count)
    {
        for (uint256 i; i < owners.length; i++) {
            if (approved[_txId][owners[i]]) {
                count += 1;
            }
        }
    }

    function execute(uint256 _txId)
        external
        txExists(_txId)
        notExecuted(_txId)
    {
        require(
            _getApprovalCount(_txId) >= numConfirmationsRequired,
            "approvals < required "
        );
        Transaction storage transaction = transactions[_txId];
        transaction.executed = true;
        _transfer(owners[0], transaction.target, transaction.amount);
        emit executeTransaction(_txId);
    }

    function revoke(uint256 _txId)
        external
        onlyOwner
        txExists(_txId)
        notExecuted(_txId)
    {
        require(approved[_txId][msg.sender], "Not approved");
        approved[_txId][msg.sender] = false;
        emit revokeTransaction(msg.sender, _txId);
    }
}
