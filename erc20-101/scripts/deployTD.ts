// Deploying the TD somewhere
// To verify it on Etherscan:
// npx hardhat verify --network <network> <address> <constructor arg 1> <constructor arg 2>
import { ethers } from "hardhat";

async function main() {
  // Deploying contracts
  const ERC20_101 = await ethers.getContractFactory("ERC20_101");
  const Evaluator = await ethers.getContractFactory("Evaluator");
  const erc20 = await ERC20_101.deploy("ERC20-101", "ERC20-101", 0);

  await erc20.waitForDeployment();

  const evaluator = await Evaluator.deploy(erc20.target);

  await evaluator.waitForDeployment();

  console.log(
    `ERC20_101 deployed at  ${erc20.target}`
  );

  console.log(
    `Evaluator deployed at ${evaluator.target}`
  );
  // Setting the teacher
  await erc20.setTeacher(evaluator.target, true)

  // Setting random values
  const randomSupplies = []
  const randomTickers = []
  for (let i = 0; i < 20; i++) {
    randomSupplies.push(Math.floor(Math.random() * 1000000000))
    randomTickers.push(Math.random().toString(36).substring(5))
  }

  console.log(randomTickers)
  console.log(randomSupplies)
  await evaluator.setRandomTickersAndSupply(randomSupplies, randomTickers);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
