# MultisigWallet Smart Contract

## Overview

The **The42TokenMultiSig** contract is an ERC20 token combined with a multi-signature wallet functionality. It allows a group of owners to collectively manage and approve token transfers, enhancing security by requiring multiple confirmations before a transaction is executed.

### Key Features:

* **ERC20 Token**: The contract creates an ERC20 token called "42token" with symbol "K42".
* **Multi-signature Wallet**: Multiple owners manage the wallet and must approve transactions before execution.
* **Transaction Submission**: Owners can propose token transfers.
* **Approval Mechanism**: Owners must approve a transaction; a minimum number of confirmations is required.
* **Execution & Revocation**: Once enough approvals are gathered, transactions can be executed. Approvals can also be revoked if necessary.

---

## Contract Details

### Constructor Parameters

* `_owners`: List of wallet owners’ addresses.
* `_numConfirmationsRequired`: Number of approvals needed to execute a transaction.

### Core Functionalities

1. **submit**
   Propose a transaction to transfer tokens to a target address.

2. **approve**
   Owners approve a submitted transaction.

3. **execute**
   Once enough approvals are collected, execute the token transfer.

4. **revoke**
   Owners can revoke their approval before execution.

### Events

* `submitTransaction`: Emitted when a new transaction is submitted.
* `approveTransaction`: Emitted when an owner approves a transaction.
* `executeTransaction`: Emitted when a transaction is executed.
* `revokeTransaction`: Emitted when an owner revokes approval.

---

## How to Deploy Using Remix Ethereum

Follow these steps to deploy the contract on Remix:

### Prerequisites

* [Remix Ethereum IDE](https://remix.ethereum.org)
* MetaMask or any Web3 wallet connected to Remix (optional for testnets or mainnet)

---

### Step-by-Step Deployment Guide

1. **Open Remix IDE**
   Go to [https://remix.ethereum.org](https://remix.ethereum.org).

2. **Create a New File**
   Click the file explorer, then create a new file named `MultisigWallet.sol`.

3. **Paste the Smart Contract Code**
   Copy your The42TokenMultiSig contract code and paste it into this file.

4. **Compile the Contract**

   * Go to the "Solidity Compiler" tab (left sidebar).
   * Select the compiler version `0.8.x` (compatible with your pragma).
   * Click `Compile The42TokenMultiSig.sol`.

5. **Configure Deployment**

   * Go to the "Deploy & Run Transactions" tab.
   * Choose your environment (e.g., JavaScript VM for testing or Injected Web3 to use MetaMask).
   * Ensure your account is selected.
   * Under the "Deploy" section, enter constructor parameters:

     * `_owners`: Array of owner addresses (e.g., `["0x1234...", "0xabcd..."]`)
     * `_numConfirmationsRequired`: Number of required approvals (e.g., `2`)

6. **Deploy**

   * Click the `Deploy` button.
   * Confirm the transaction if using MetaMask or wait for the deployment in the JavaScript VM.

7. **Interact with the Contract**

   * After deployment, your contract instance will appear under "Deployed Contracts".
   * Expand it to call functions like `submit`, `approve`, `execute`, `revoke`.
   * You can also check token balances and owners.

---

## Example Usage

1. **Submit a Transaction**
   Call `submit` with a target address and amount of tokens to transfer.

2. **Approve the Transaction**
   Each owner calls `approve` with the transaction ID.

3. **Execute the Transaction**
   Once enough owners have approved, call `execute` with the transaction ID to transfer tokens.

4. **Revoke Approval**
   An owner can call `revoke` before execution if they change their mind.

---

## Notes

* Each owner receives 1337 tokens initially.
* Token transfers through this wallet require multiple owners' approval, improving security.
* This contract extends OpenZeppelin's ERC20 implementation; ensure you have the correct OpenZeppelin imports when compiling.
