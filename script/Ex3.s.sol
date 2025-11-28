// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {MonERC20} from "../src/MonERC20.sol";

interface IEvaluator {
    function submitExercice(address studentExercice) external;
    function ex3_testGetToken() external;
}

contract Ex3 is Script {
    function run() external {
        string memory mnemonic = vm.envString("MNEMONIC");
        uint256 deployerPrivateKey = vm.deriveKey(mnemonic, 0);

        address evaluator = 0x05A644d6d9BBd85861ff927245aaC13bd56e6d57;
        uint256 initialSupply = 533983428000000000000000000;

        vm.startBroadcast(deployerPrivateKey);

        // 1. Deploy MonERC20
        console.log("Deploying MonERC20 with getToken()...");
        MonERC20 token = new MonERC20(initialSupply);
        console.log("MonERC20 deployed at:", address(token));

        // 2. Submit Exercise
        console.log("Submitting exercise...");
        IEvaluator(evaluator).submitExercice(address(token));

        // 3. Test getToken
        console.log("Testing ex3_testGetToken...");
        IEvaluator(evaluator).ex3_testGetToken();

        vm.stopBroadcast();
    }
}
