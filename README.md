# 🏦 MultiAssetVaultBank

📖 **Description**  
**MultiAssetVaultBank** is a smart contract written in Solidity (^0.8.24) that serves as a multi-asset custodial vault. It allows users to securely deposit and withdraw both **ETH** and **ERC20 tokens**, manage internal ETH transfers between users, and includes admin functionality for recovering untracked funds. This contract is ideal for intermediate DeFi projects, multisig vaults, or tokenized custody services.

Whether you're building a secure treasury, a user-facing crypto bank, or a vault for DAO operations, **MultiAssetVaultBank** provides a robust foundation.

---

## ✨ Key Features

- **ETH & Token Deposits**: Accepts ETH and any ERC20 token with accurate internal balance accounting.
- **User Withdrawals**: Users can withdraw their ETH or token balances at any time.
- **Internal ETH Transfers**: Allows ETH transfers between users without leaving the contract.
- **Admin Recovery**: Admin can recover ETH accidentally sent without calling `depositEth()`.
- **Transparent Events**: Events emitted for all actions to enable full on-chain auditing.
- **Safe ETH Handling**: Fallback and receive functions reject unintended transfers.

---

## 💼 Use Cases

- **Multi-token vaults** for DeFi protocols or DAO treasuries.
- **Crypto banks** managing ETH and token balances per user.
- **Custodial interfaces** needing internal user balances.
- **Intermediary settlement layers** for dApps and games.
- **Learning tool** for advanced Solidity: nested mappings, event handling, recovery patterns.

---

## 🚀 Installation & Usage

### 🧱 Requirements

- Solidity development environment (e.g. **Remix**, **Hardhat**, **Foundry**)
- Ethereum wallet (e.g. **MetaMask**)
- Ethereum node access (e.g. **Remix VM**, **Hardhat localnet**, or **Sepolia testnet**)

### 📦 Deployment Steps

1. Open `MultiAssetVaultBank.sol` in your preferred environment.
2. Compile using Solidity `^0.8.24`.
3. Deploy with an admin address as the constructor parameter.
4. Interact using the exposed functions (see below).

---

## 💬 Interacting with the Contract

### 1. Deposit ETH (`depositEth`)
- Called by any user.
- Sends ETH via `msg.value`.
- Updates internal ETH balance.
- Emits `EtherDeposited`.

```solidity
function depositEth() external payable;

