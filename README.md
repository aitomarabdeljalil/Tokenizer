# Tokenizer

## Overview

the42token is an ERC20-compliant token with two implementations demonstrating different security and control paradigms:

1. **Basic Implementation**: Standard ERC20 token with fixed supply (1337 tokens)
2. **Multisignature Implementation**: Enhanced version requiring multiple approvals for transfers

## Language Choice

**Solidity** Selected for its:

Native Ethereum Virtual Machine (EVM) compatibility

Mature tooling (Remix, Hardhat, Foundry)

Secure arithmetic operations (built-in overflow checks)

Industry-wide adoption for smart contracts

## Implementation Decisions

### 1. Basic Token Design Choices

- **Fixed Supply**: 1337 tokens (demonstrating finite supply concept)
- **18 Decimals**: Standard ERC20 precision for broad compatibility
- **Explicit Ownership**: All tokens minted to deployer for simplicity
- **Minimal Functions**: Strictly ERC20 compliant without extensions

_Rationale_: Designed as a reference implementation showing the most basic compliant ERC20 token.

### 2. Multisig Implementation Choices

- **Contract-held Tokens**: All tokens remain in contract custody
- **Configurable Governance**:
  - Dynamic owner set (3 default owners in implementation)
  - Adjustable confirmation threshold (2/3 default)
- **Transaction Lifecycle**:
  - Clear submit → confirm → execute flow
  - Full transaction visibility

_Rationale_: Created to demonstrate secure token management for organizational use.

## Project Structure

```
      42_TOKENIZER/
      ├── code/
      │   ├── the42token.sol                            # Basic implementation
      │   └── the42TokenMultiSig.sol                    # Multisignature implementation
      ├── deployment/
      │   ├── mandatory_DEPLOYMENT.md                   # How to deploy basic implementation
      │   └── bonus_DEPLOYMENT.md                       # How to deploy multisig implementation
      ├── documentation/
      │   ├── mandatory_DOCUMENTATION.md                # How to use basic implementation
      │   └── bonus_DOCUMENTATION.md                    # How to use multisig implementation
      └── README.md                                     # This file
```

### Implementation Choices

This project offers two different token implementations to demonstrate the spectrum of complexity in token design:

1. **Basic Implementation**: A minimal ERC20 token suitable for simple use cases where a standard token is needed without additional security features. This implementation assigns all tokens to the deployer, making it suitable for projects where centralized control is acceptable.

2. **Multisignature Implementation**: An advanced token with enhanced governance features. This implementation requires multiple signatures to authorize transfers, making it more suitable for:
   - Projects requiring shared control
   - High-value tokens where security is paramount

The multisig implementation stores all tokens within the owners, requiring a consensus-based approach for any token movement.

### Quick Start Guide

#### Step 1: Deploy Your Token

1. Open [Remix Ethereum IDE](https://remix.ethereum.org/)
2. Create a new Solidity file
3. Copy the contract code from either:
   - `code/he42token.sol` (basic implementation)
   - `code/the42TokenMultiSig.sol` (multisig implementation)
4. Compile the contract in Remix
5. Deploy using MetaMask or your preferred Ethereum wallet

For detailed deployment instructions, refer to:

- [mandatory_DEPLOYMENT.md](./deployment/mandatory_DEPLOYMENT.md)
- [bonus_DEPLOYMENT.md](./deployment/bonus_DEPLOYMENT.md)

#### Step 2: Interact with Your Token

**For Basic Token:**

- After deployment, all tokens will be in your deployer wallet
- Use standard ERC20 functions to transfer and manage tokens

**For Multisig Token:**

- After deployment, all tokens will be held by the owners
- Use the multisig process (submit, confirm, execute, refoke) to transfer tokens

#### Step 3: Refer to Documentation

For detailed usage instructions:

- Basic implementation: [mandatory_DOCUMENTATION.md](./documentation/mandatory_DOCUMENTATION.md)
- Multisig implementation: [bonus_DOCUMENTATION.md](./documentation/bonus_DOCUMENTATION.md)

## Security Considerations

- The basic implementation centralizes control with the deployer
- The multisig implementation distributes control among multiple owners
- Always deploy to a testnet first before using in production

## Development Environment

This project was developed using [Remix Ethereum IDE](https://remix.ethereum.org/), which offers:

- Web-based accessibility
- Integrated compilation and deployment
- Easy interaction with deployed contracts
- Support for importing OpenZeppelin contracts