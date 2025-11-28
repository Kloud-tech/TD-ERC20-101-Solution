// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IAllInOneSolution {
    function completeWorkshop() external;
}

interface IEvaluator {
    function ex1_getTickerAndSupply() external;
    function submitExercice(address studentExercice) external;
    function ex2_testErc20TickerAndSupply() external;
    function ex3_testGetToken() external;
    function ex4_testBuyToken() external;
    function ex5_testDenyListing() external;
    function ex6_testAllowListing() external;
    function ex7_testDenyListing() external;
    function ex8_testTier1Listing() external;
    function ex9_testTier2Listing() external;
    function readTicker(
        address studentAddress
    ) external view returns (string memory);
    function readSupply(address studentAddress) external view returns (uint256);
}

import {DynamicERC20} from "./DynamicERC20.sol";

/**
 * Ex10: All-in-One Solution
 * This contract completes the entire workshop programmatically in a single transaction
 */
contract AllInOneSolution is IAllInOneSolution {
    address public constant EVALUATOR =
        0x05A644d6d9BBd85861ff927245aaC13bd56e6d57;
    DynamicERC20 public deployedToken;

    /**
     * Completes all exercises in one transaction
     */
    function completeWorkshop() external override {
        IEvaluator evaluator = IEvaluator(EVALUATOR);

        // Ex1: Get assigned ticker and supply
        evaluator.ex1_getTickerAndSupply();

        // Retrieve assigned values
        string memory ticker = evaluator.readTicker(address(this));
        uint256 supply = evaluator.readSupply(address(this));

        // Ex2: Deploy ERC20 with correct ticker and supply
        deployedToken = new DynamicERC20(supply, ticker);

        evaluator.submitExercice(address(deployedToken));
        evaluator.ex2_testErc20TickerAndSupply();

        // Ex3: Test getToken (requires whitelisting evaluator first)
        deployedToken.addToWhitelist(EVALUATOR, 1);
        evaluator.ex3_testGetToken();

        // Ex4: Test buyToken (evaluator already whitelisted tier 1)
        evaluator.ex4_testBuyToken();

        // Ex5: Test deny listing (remove from whitelist)
        deployedToken.removeFromWhitelist(EVALUATOR);
        evaluator.ex5_testDenyListing();

        // Ex6: Test allow listing (add back to whitelist)
        deployedToken.addToWhitelist(EVALUATOR, 1);
        evaluator.ex6_testAllowListing();

        // Ex7: Test deny tier 0 (remove from whitelist)
        deployedToken.removeFromWhitelist(EVALUATOR);
        evaluator.ex7_testDenyListing();

        // Ex8: Test tier 1 listing
        deployedToken.addToWhitelist(EVALUATOR, 1);
        evaluator.ex8_testTier1Listing();

        // Ex9: Test tier 2 listing (upgrade to tier 2)
        deployedToken.addToWhitelist(EVALUATOR, 2);
        evaluator.ex9_testTier2Listing();

        // All exercises completed! 18 points earned
    }

    /**
     * Allow receiving ETH (in case needed)
     */
    receive() external payable {}
}
