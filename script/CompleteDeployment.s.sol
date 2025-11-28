// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {MonERC20} from "../src/MonERC20.sol";

interface IEvaluator {
    function submitExercice(address studentExercice) external;
    function ex4_testBuyToken() external;
    function ex5_testDenyListing() external;
    function ex6_testAllowListing() external;
    function ex7_testDenyListing() external;
    function ex8_testTier1Listing() external;
    function ex9_testTier2Listing() external;
}

contract CompleteDeployment is Script {
    function run() external {
        string memory mnemonic = vm.envString("MNEMONIC");
        uint256 deployerPrivateKey = vm.deriveKey(mnemonic, 0);

        address evaluator = 0x05A644d6d9BBd85861ff927245aaC13bd56e6d57;
        uint256 initialSupply = 533983428000000000000000000;

        vm.startBroadcast(deployerPrivateKey);

        // 1. Deploy MonERC20 with all features
        console.log("===== DEPLOYING COMPLETE CONTRACT =====");
        MonERC20 token = new MonERC20(initialSupply);
        console.log("MonERC20 deployed at:", address(token));

        // 2. Submit to evaluator
        console.log("\n===== SUBMITTING TO EVALUATOR =====");
        IEvaluator(evaluator).submitExercice(address(token));
        console.log("Contract submitted successfully");

        // 3. Test Ex4 - buyToken (basic)
        console.log("\n===== TESTING EX4: buyToken =====");
        // Evaluator is NOT whitelisted yet, so this should work for basic buyToken test
        // But we need to whitelist it first
        token.addToWhitelist(evaluator, 1); // Add evaluator to tier 1
        IEvaluator(evaluator).ex4_testBuyToken();
        console.log("Ex4 passed: buyToken works");

        // 4. Test Ex5 - Deny listing (remove from whitelist)
        console.log("\n===== TESTING EX5: Deny Listing =====");
        token.removeFromWhitelist(evaluator);
        IEvaluator(evaluator).ex5_testDenyListing();
        console.log("Ex5 passed: Non-whitelisted users denied");

        // 5. Test Ex6 - Allow listing (add to whitelist)
        console.log("\n===== TESTING EX6: Allow Listing =====");
        token.addToWhitelist(evaluator, 1); // Re-add to whitelist
        IEvaluator(evaluator).ex6_testAllowListing();
        console.log("Ex6 passed: Whitelisted users allowed");

        // 6. Test Ex7 - Deny tier 0
        console.log("\n===== TESTING EX7: Deny Tier 0 =====");
        token.removeFromWhitelist(evaluator); // Remove from whitelist (tier becomes 0)
        IEvaluator(evaluator).ex7_testDenyListing();
        console.log("Ex7 passed: Tier 0 users denied");

        // 7. Test Ex8 - Tier 1 listing
        console.log("\n===== TESTING EX8: Tier 1 Listing =====");
        token.addToWhitelist(evaluator, 1); // Add with tier 1
        IEvaluator(evaluator).ex8_testTier1Listing();
        console.log("Ex8 passed: Tier 1 pricing works");

        // 8. Test Ex9 - Tier 2 listing (2x tokens)
        console.log("\n===== TESTING EX9: Tier 2 Listing =====");
        token.addToWhitelist(evaluator, 2); // Upgrade to tier 2
        IEvaluator(evaluator).ex9_testTier2Listing();
        console.log("Ex9 passed: Tier 2 gets 2x tokens");

        console.log("\n===== ALL EXERCISES COMPLETED! =====");

        vm.stopBroadcast();
    }
}
