// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {AllInOneSolution} from "../src/AllInOneSolution.sol";

interface IEvaluator {
    function ex10_allInOne() external;
}

contract DeployEx10 is Script {
    function run() external {
        string memory mnemonic = vm.envString("MNEMONIC");
        // Use index 1 instead of 0 to get a fresh address with 0 points
        uint256 deployerPrivateKey = vm.deriveKey(mnemonic, 1);

        address evaluator = 0x05A644d6d9BBd85861ff927245aaC13bd56e6d57;

        console.log("Deployer address:", vm.addr(deployerPrivateKey));

        vm.startBroadcast(deployerPrivateKey);

        console.log("===== DEPLOYING ALL-IN-ONE SOLUTION =====");
        AllInOneSolution solution = new AllInOneSolution();
        console.log("AllInOneSolution deployed at:", address(solution));

        console.log("\n===== RUNNING EX10: ALL-IN-ONE =====");
        IEvaluator(evaluator).ex10_allInOne();
        console.log("Ex10 completed! Workshop solved programmatically!");

        vm.stopBroadcast();
    }
}
