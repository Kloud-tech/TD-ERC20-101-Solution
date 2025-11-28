// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

interface IEvaluator {
    function ex1_getTickerAndSupply() external;
    function readTicker(
        address studentAddress
    ) external view returns (string memory);
    function readSupply(address studentAddress) external view returns (uint256);
}

contract GetAssignedValues is Script {
    function run() external {
        string memory mnemonic = vm.envString("MNEMONIC");
        uint256 deployerPrivateKey = vm.deriveKey(mnemonic, 0);
        address deployerAddress = vm.addr(deployerPrivateKey);

        address evaluator = 0x05A644d6d9BBd85861ff927245aaC13bd56e6d57;

        vm.startBroadcast(deployerPrivateKey);

        console.log("Calling ex1_getTickerAndSupply...");
        IEvaluator(evaluator).ex1_getTickerAndSupply();

        string memory ticker = IEvaluator(evaluator).readTicker(
            deployerAddress
        );
        uint256 supply = IEvaluator(evaluator).readSupply(deployerAddress);

        console.log("Assigned Ticker:", ticker);
        console.log("Assigned Supply:", supply);

        vm.stopBroadcast();
    }
}
