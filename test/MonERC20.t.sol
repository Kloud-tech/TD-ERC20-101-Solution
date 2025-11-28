// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {MonERC20} from "../src/MonERC20.sol";

contract MonERC20Test is Test {
    MonERC20 public token;
    uint256 public initialSupply = 810077968000000000000000000;

    function setUp() public {
        token = new MonERC20(initialSupply);
    }

    function testTicker() public {
        assertEq(token.symbol(), "sewpjhga");
    }

    function testSupply() public {
        assertEq(token.totalSupply(), initialSupply);
    }
}
