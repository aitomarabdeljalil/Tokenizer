# The42TokenMultiSig - ERC20 Token with Multisig Transfer Control

This project provides a Solidity smart contract, `The42TokenMultiSig.sol`, implementing an ERC20 token with multisignature (multisig) transfer control for enhanced security and governance.

## 🚀 Overview

`The42TokenMultiSig` is an ERC20-compliant token contract named "42token" (symbol: K42) that requires multiple owner approvals to execute token transfers. It extends OpenZeppelin's `ERC20` contract and includes multisig mechanisms to ensure secure, collaborative management of token movements.

### Key Features
- **Token Standard**: ERC20
- **Name**: 42token
- **Symbol**: K42
- **Multisig Control**: Transfers require approval from a predefined number of owners
- **Initial Minting**: Each owner receives 1337 tokens (scaled by 10^18 for decimals)
- **Security**: Includes checks for valid owners, non-zero addresses, and transaction states

---

## 📝 Contract Details

### Dependencies
- `@openzeppelin/contracts/token/ERC20/ERC20.sol`

### Solidity Version
- `^0.8.20`

### License
- MIT

### State Variables
- `owners` (`address[]`, public): Array of owner addresses
- `numConfirmationsRequired` (`uint256`, public): Number of approvals needed for a transfer
- `isOwner` (`mapping(address => bool)`, public): Tracks if an address is an owner
- `transactions` (`Transaction[]`, public): Array of pending transfer transactions
- `approved` (`mapping(uint256 => mapping(address => bool))`, public): Tracks approvals per transaction

### Struct
- `Transaction`:
  - `target` (`address`): Recipient of the token transfer
  - `amount` (`uint256`): Amount of tokens to transfer
  - `executed` (`bool`): Whether the transaction has been executed

### Constructor
- **Parameters**:
  - `_owners` (`address[]`): List of owner addresses
  - `_numConfirmationsRequired` (`uint256`): Number of confirmations needed
- **Behavior**:
  - Validates non-empty owner list and valid confirmation threshold
  - Ensures unique, non-zero owner addresses
  - Mints 1337 tokens (scaled by 10^18) to each owner
  - Sets up multisig variables

### Functions

#### `submit(address _target, uint256 _amount) external onlyOwner`
- **Purpose**: Submits a new transfer transaction
- **Parameters**:
  - `_target`: Recipient address
  - `_amount`: Token amount to transfer
- **Behavior**:
  - Validates non-zero target and amount
  - Adds transaction to `transactions` array
  - Emits `submitTransaction` event

#### `approve(uint256 _txId) external onlyOwner txExists(_txId) notApproved(_txId) notExecuted(_txId)`
- **Purpose**: Approves a pending transaction
- **Parameters**:
  - `_txId`: Transaction ID
- **Behavior**:
  - Marks transaction as approved by the caller
  - Emits `approveTransaction` event

#### `_getApprovalCount(uint256 _txId) public view returns (uint256)`
- **Purpose**: Counts approvals for a transaction
- **Parameters**:
  - `_txId`: Transaction ID
- **Returns**: Number of owners who approved the transaction

#### `execute(uint256 _txId) external txExists(_txId) notExecuted(_txId)`
- **Purpose**: Executes an approved transaction
- **Parameters**:
  - `_txId`: Transaction ID
- **Behavior**:
  - Requires approvals >= `numConfirmationsRequired`
  - Transfers tokens from the first owner to the target
  - Marks transaction as executed
  - Emits `executeTransaction` event

#### `revoke(uint256 _txId) external onlyOwner txExists(_txId) notExecuted(_txId)`
- **Purpose**: Revokes approval for a pending transaction
- **Parameters**:
  - `_txId`: Transaction ID
- **Behavior**:
  - Requires caller to have previously approved the transaction
  - Removes approval
  - Emits `revokeTransaction` event

### Events
- `submitTransaction(uint256 indexed transactionId)`
- `approveTransaction(address indexed owner, uint256 transactionId)`
- `executeTransaction(uint256 indexed transactionId)`
- `revokeTransaction(address indexed owner, uint256 transactionId)`

### Modifiers
- `onlyOwner`: Restricts to owner addresses
- `txExists(_txId)`: Ensures transaction ID is valid
- `notApproved(_txId)`: Ensures caller hasn’t already approved
- `notExecuted(_txId)`: Ensures transaction isn’t executed

---

## 🖼️ Usage

1. **Submit Transaction**:
   - Call `submit(target, amount)` to propose a token transfer
   - Example: `submit("0xRecipient", 1000000000000000000)` for 1 token
2. **Approve Transaction**:
   - Owners call `approve(txId)` to approve the transaction
   - Check approval count with `_getApprovalCount(txId)`
3. **Execute Transaction**:
   - Call `execute(txId)` when enough approvals are received
   - Tokens transfer from the first owner to the target
4. **Revoke Approval**:
   - Owners call `revoke(txId)` to withdraw approval if needed
5. **View Balances**:
   - Use `balanceOf(address)` to check token balances

---

## ⚠️ Security Considerations
- **Multisig**: Transfers require multiple approvals, enhancing security
- **Owner Validation**: Prevents null or duplicate owners
- **Gas Costs**: On-chain storage of transactions and approvals can be costly
- **First Owner**: Tokens are transferred from `owners[0]`; ensure this address has sufficient balance
- **Testnet**: Test on Sepolia or similar before mainnet deployment

---

## 📝 Notes
- **Testnet**: Deploy on testnets (e.g., Sepolia) for testing
- **Tools**: Use Remix, Hardhat, or Foundry for deployment
- **Future Improvements**:
  - Add a maximum token supply
  - Allow dynamic owner management
  - Support batch transactions

## License
Licensed under the MIT License.