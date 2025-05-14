# Ozean Bridge - Senior Smart Contract Engineering Test

This repository contains a Foundry project that demonstrates how to:

1. Deploy an ERC20 token on Ethereum Sepolia testnet (L1)
2. Deploy a bridged representation of that token on Ozean's Poseidon testnet (L2)
3. Bridge assets between L1 and L2 using the OP Standard Bridge

## Prerequisites

1. [Foundry](https://book.getfoundry.sh/getting-started/installation) installed
2. Access to Sepolia testnet ETH (for gas fees)
3. Access to Ozean testnet ETH (for gas fees on L2)
4. An RPC endpoint for Sepolia (e.g., Infura, Alchemy)

## Setup

1. Clone the repository:

```bash
git clone <repository-url>
cd ozean-bridge
```

2. Install dependencies:

```bash
forge install
```

3. Create a `.env` file based on `.env.example`:

```bash
cp .env.example .env
```

4. Fill in the required environment variables:
   - `PRIVATE_KEY`: Your wallet private key
   - `SEPOLIA_RPC_URL`: Your Sepolia RPC endpoint
   - `OZEAN_RPC_URL`: Ozean testnet RPC
   - `ETHERSCAN_API_KEY`: For contract verification

## Deployment

### Step 1: Deploy L1 Token on Sepolia

```bash
forge script script/deploy/DeployL1Token.s.sol \
  --rpc-url sepolia \
  --broadcast \
  --verify \
  -vvvv
```

This will:

- Deploy the ERC20 token on Sepolia
- Mint 1,000,000 tokens to the deployer
- Output the deployed token address

Save the L1 token address in your `.env` file:

```
L1_TOKEN_ADDRESS=<deployed_address>
```

### Step 2: Deploy L2 Token on Ozean

```bash
forge script script/deploy/DeployL2Token.s.sol \
  --rpc-url ozean \
  --broadcast \
  -vvvv
```

This will:

- Deploy the OptimismMintableERC20 token on Ozean
- Link it to the L1 token
- Configure it to work with the L2StandardBridge

Save the L2 token address in your `.env` file:

```
L2_TOKEN_ADDRESS=<deployed_address>
```

## Bridging Operations

### Bridge from L1 to L2

1. First, ensure you have tokens in your L1 wallet
2. Run the bridge script:

```bash
forge script script/bridge/BridgeL1ToL2.s.sol \
  --rpc-url sepolia \
  --broadcast \
  -vvvv
```

This will:

- Approve the L1 bridge to spend your tokens
- Deposit tokens into the L1 bridge
- The tokens will be minted on L2 after the cross-chain message is relayed (usually within minutes)

### Bridge from L2 to L1

1. Ensure you have tokens in your L2 wallet
2. Run the bridge script:

```bash
forge script script/bridge/BridgeL2ToL1.s.sol \
  --rpc-url ozean \
  --broadcast \
  -vvvv
```

This will:

- Burn tokens on L2
- Initiate a withdrawal to L1
- Note: Withdrawals from L2 to L1 require a challenge period and manual finalization

## Testing

The project includes comprehensive tests for all contracts:

```bash
# Run all tests
forge test

# Run with verbosity
forge test -vvvv

# Run specific test file
forge test --match-path test/L1Token.t.sol
```

## Bridge Addresses

- **L1 Standard Bridge (Sepolia)**: `0x8f42BD64b98f35EC696b968e3ad073886464dEC1`
- **L2 Standard Bridge (Ozean)**: `0x4200000000000000000000000000000000000010`

## Key Considerations

1. **Challenge Period**: Withdrawals from L2 to L1 involve a 7-day challenge period for security
2. **Gas Requirements**: Ensure you have sufficient gas on both networks
3. **Token Compatibility**: The L2 token must implement the IOptimismMintableERC20 interface

## Project Structure

```
ozean-bridge/
├── src/
│   ├── tokens/
│   │   ├── L1Token.sol
│   │   └── L2Token.sol
│   └── interfaces/
│       └── StandardBridge.sol
├── script/
│   ├── deploy/
│   │   ├── DeployL1Token.s.sol
│   │   └── DeployL2Token.s.sol
│   └── bridge/
│       ├── BridgeL1ToL2.s.sol
│       └── BridgeL2ToL1.s.sol
├── test/
│   ├── L1Token.t.sol
│   ├── L2Token.t.sol
│   └── Bridge.t.sol
├── .env.example
├── foundry.toml
└── README.md
```

## Deployed contract

1. Poseidon's token: https://poseidon-testnet.explorer.caldera.xyz/address/0x87e6eb40b13bb84516560259e67ec5fce8f198f3?tab=txs

2. Sepolia's token: https://eth-sepolia.blockscout.com/address/0xEC642550ef8F3Bc4E7Bf26F0dCA9744b72eE7268

## Troubleshooting

1. **Insufficient Gas**: Ensure you have enough ETH on both networks
2. **Bridge Not Found**: Verify the L1 bridge address for the Sepolia<->Ozean route
3. **Token Not Minted**: Wait for the cross-chain message to be relayed (check explorer)

## License

MIT
