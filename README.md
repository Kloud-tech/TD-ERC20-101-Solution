# ERC20-101 Solution (Foundry)

This repository contains my solution to the ERC20-101 Solidity workshop. It implements an ERC20 token with whitelist and tiered sale mechanics, plus automation scripts and an all-in-one contract that drive the evaluator flow on Sepolia. It is designed as a concise demonstration of Solidity and Foundry skills for a recruiter review.

## Highlights
- ERC20 implementation with allowlist control and tier-based pricing.
- Dynamic ERC20 deployment to match evaluator-assigned ticker and supply.
- All-in-one contract that completes the workshop flow in a single transaction.
- Foundry scripts for repeatable deployments and evaluator calls.
- Minimal tests to validate symbol and total supply.

## Tech Stack
- Solidity 0.8.x
- Foundry (forge, cast)
- OpenZeppelin ERC20 + Ownable

## Project Structure
- `src/MonERC20.sol`: main ERC20 solution with whitelist and tiers.
- `src/DynamicERC20.sol`: parameterized ERC20 used for the all-in-one flow.
- `src/AllInOneSolution.sol`: orchestrates the evaluator flow end to end.
- `script/*.s.sol`: Foundry scripts to deploy and run each exercise.
- `test/MonERC20.t.sol`: simple unit tests.

## Run Locally (build and test)
Prerequisites: Foundry installed (`foundryup`).

```bash
forge build
forge test
```

## Run on Sepolia (evaluator flow)
Set environment variables (example):

```bash
export MNEMONIC="your twelve words here"
export SEPOLIA_RPC_URL="https://sepolia.infura.io/v3/your_key"
export ETHERSCAN_API_KEY="your_key" # optional, only for verification
```

Retrieve the assigned ticker and supply:

```bash
forge script script/GetAssignedValues.s.sol:GetAssignedValues \
  --rpc-url "$SEPOLIA_RPC_URL" --broadcast
```

Deploy the token and validate the basic ERC20 exercise:

```bash
forge script script/Solution.s.sol:Solution \
  --rpc-url "$SEPOLIA_RPC_URL" --broadcast
```

Run the full whitelist and tier flow:

```bash
forge script script/CompleteDeployment.s.sol:CompleteDeployment \
  --rpc-url "$SEPOLIA_RPC_URL" --broadcast
```

Run the all-in-one completion (exercise 10):

```bash
forge script script/DeployEx10.s.sol:DeployEx10 \
  --rpc-url "$SEPOLIA_RPC_URL" --broadcast
```

## Notes
- Evaluator addresses are currently hard-coded for Sepolia in the scripts and `src/AllInOneSolution.sol`. Update them if you target another network (e.g., Holesky).
- The workshop spec and evaluator contracts live in `erc20-101/README.md` for reference.
