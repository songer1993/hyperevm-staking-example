# Hyperliquid EVM Staking Example

A simple example demonstrating how to deploy and interact with ERC20 token staking contracts on the Hyperliquid EVM testnet.

## Prerequisites

- Python 3.8+
- Web3.py
- Access to Hyperliquid testnet
- Test ETH in your wallet

## Installation
1. Clone the repository:
```shell
git clone https://github.com/songer1993/hyperevm-staking-example.git
cd hyperevm-staking-example
```

2. Install dependencies:
```shell
pip install web3 python-dotenv eth-account
```

3. Create a `.env` file in the root directory:
```plaintext
DEPLOYER_PRIVATE_KEY='your_private_key_here'
STAKER_PRIVATE_KEY='your_staker_private_key_here'
TOKEN_ADDRESS='deployed_token_address'
STAKING_ADDRESS='deployed_staking_address'
```

## Contract Details

The project includes two main contracts:

1. ERC20 Token Contract (MyToken):
   - Initial supply of 1,000,000 MTK tokens
   - Standard ERC20 functions (transfer, approve, transferFrom, etc.)

2. Staking Contract (MTKStaking):
   - Stake tokens and earn rewards
   - Features:
     - `stake(uint256)`: Stake tokens
     - `withdraw(uint256)`: Withdraw staked tokens
     - `claimRewards()`: Claim accumulated rewards
     - `depositRewards(uint256)`: Owner can deposit rewards
     - `emergencyWithdraw()`: Emergency withdrawal function
     - Reward calculation based on staking duration

## Usage

See `staking-example.ipynb` for deployment and testing. The notebook includes:
- Contract deployment
- Token transfers
- Staking tokens
- Claiming rewards
- Withdrawing stakes

## Project Structure

```plaintext
├── bin/
│ └── contracts/
│ ├── IERC20.json # ERC20 interface
│ ├── MTKStaking.json # Staking contract
│ ├── MTKStaking.abi # Contract ABI
│ └── IERC20.abi # ERC20 interface ABI
├── contracts/
│ └── MTKStaking.sol # Solidity source code
├── staking-example.ipynb # Jupyter notebook for testing
├── requirements.txt # Python dependencies
├── README.md # Project documentation
├── .env # Environment variables (not in git)
└── .gitignore # Git ignore rules
```

## Security

- Never commit your private keys or `.env` file
- Use testnet for development
- Always review transactions before signing

## Network Details

- Network: Hyperliquid Testnet
- RPC URL: https://api.hyperliquid-testnet.xyz/evm

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Hyperliquid team for the testnet
- Web3.py documentation
