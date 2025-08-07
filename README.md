# Aave Flash Loan Arbitrage Project

This is a DeFi arbitrage project that implements flash loan functionality using Aave's V3 protocol to execute arbitrage opportunities between different decentralized exchanges (DEXs). The project demonstrates how to leverage flash loans to profit from price differences across trading venues without requiring upfront capital.

## Project Overview

This project demonstrates a basic Hardhat use case with advanced DeFi functionality. It comes with sample contracts, tests for those contracts, and Hardhat Ignition modules that deploy the contracts.

## Features

- **Flash Loan Integration**: Uses Aave V3 protocol for flash loans
- **Arbitrage Strategy**: Implements cross-DEX arbitrage opportunities
- **Smart Contract Testing**: Comprehensive test suite
- **Deployment Scripts**: Automated deployment using Hardhat Ignition

## Quick Start

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/Lock.js
```

## Project Structure

- `contracts/`: Smart contracts including FlashLoanArbitrage and Dex
- `test/`: Test files for contract functionality
- `scripts/`: Deployment scripts
- `ignition/`: Hardhat Ignition deployment modules
