// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";
import {IExerciceSolution} from "./IExerciceSolution.sol";

/**
 * Dynamic ERC20 for Ex10 All-in-One Solution
 * Accepts ticker and supply as constructor parameters
 */
contract DynamicERC20 is ERC20, Ownable, IExerciceSolution {
    mapping(address => bool) private whitelist;
    mapping(address => uint256) private tierLevel;

    uint256 public constant TOKEN_PRICE = 1000;
    uint256 public constant PRICE_DENOMINATOR = 0.0001 ether;

    string private _symbol;

    constructor(uint256 initialSupply, string memory tokenSymbol)
        ERC20("DynamicERC20", tokenSymbol)
        Ownable(msg.sender)
    {
        _symbol = tokenSymbol;
        _mint(msg.sender, initialSupply);
    }

    function symbol() public view override(ERC20, IExerciceSolution) returns (string memory) {
        return _symbol;
    }

    function addToWhitelist(address customer, uint256 tier) external onlyOwner {
        whitelist[customer] = true;
        tierLevel[customer] = tier;
    }

    function removeFromWhitelist(address customer) external onlyOwner {
        whitelist[customer] = false;
        tierLevel[customer] = 0;
    }

    function getToken() external override returns (bool) {
        require(whitelist[msg.sender], "Not whitelisted");
        _mint(msg.sender, 1000 * 10 ** decimals());
        return true;
    }

    function buyToken() external payable override returns (bool) {
        require(whitelist[msg.sender], "Not whitelisted");
        require(tierLevel[msg.sender] > 0, "No tier assigned");

        uint256 baseTokens = (msg.value * TOKEN_PRICE) / PRICE_DENOMINATOR;
        uint256 multiplier = tierLevel[msg.sender];
        uint256 tokensToMint = baseTokens * multiplier;

        _mint(msg.sender, tokensToMint);
        return true;
    }

    function isCustomerWhiteListed(address customerAddress) external view override returns (bool) {
        return whitelist[customerAddress];
    }

    function customerTierLevel(address customerAddress) external view override returns (uint256) {
        return tierLevel[customerAddress];
    }

    receive() external payable {}
}
