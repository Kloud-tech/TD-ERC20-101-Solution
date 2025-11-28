// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";
import {IExerciceSolution} from "./IExerciceSolution.sol";

contract MonERC20 is ERC20, Ownable, IExerciceSolution {
    // Whitelist and tier management
    mapping(address => bool) private whitelist;
    mapping(address => uint256) private tierLevel;

    // Token pricing: 1000 tokens per 0.0001 ETH at tier 1
    uint256 public constant TOKEN_PRICE = 1000;
    uint256 public constant PRICE_DENOMINATOR = 0.0001 ether;

    constructor(uint256 initialSupply) ERC20("MonERC20", "giw4o5i") Ownable(msg.sender) {
        _mint(msg.sender, initialSupply);
    }

    function symbol() public view override(ERC20, IExerciceSolution) returns (string memory) {
        return super.symbol();
    }

    // Admin functions - Whitelist & Tier Management

    /**
     * @dev Add a customer to whitelist with a specific tier level
     * @param customer Address to whitelist
     * @param tier Tier level (0 = no access, 1 = basic, 2 = premium)
     */
    function addToWhitelist(address customer, uint256 tier) external onlyOwner {
        whitelist[customer] = true;
        tierLevel[customer] = tier;
    }

    /**
     * @dev Remove a customer from whitelist
     * @param customer Address to remove
     */
    function removeFromWhitelist(address customer) external onlyOwner {
        whitelist[customer] = false;
        tierLevel[customer] = 0;
    }

    // IExerciceSolution implementation

    /**
     * @dev Free token distribution (requires whitelist)
     * Ex3: Works without whitelist
     * Ex5-6: Requires whitelist
     */
    function getToken() external override returns (bool) {
        require(whitelist[msg.sender], "Not whitelisted");
        _mint(msg.sender, 1000 * 10 ** decimals());
        return true;
    }

    /**
     * @dev Buy tokens with ETH (requires whitelist and tier > 0)
     * Tier 1: base price (1000 tokens per 0.0001 ETH)
     * Tier 2: 2x tokens for same price
     */
    function buyToken() external payable override returns (bool) {
        require(whitelist[msg.sender], "Not whitelisted");
        require(tierLevel[msg.sender] > 0, "No tier assigned");

        // Calculate base tokens from ETH amount
        uint256 baseTokens = (msg.value * TOKEN_PRICE) / PRICE_DENOMINATOR;

        // Apply tier multiplier (tier 1 = 1x, tier 2 = 2x, etc.)
        uint256 multiplier = tierLevel[msg.sender];
        uint256 tokensToMint = baseTokens * multiplier;

        _mint(msg.sender, tokensToMint);
        return true;
    }

    /**
     * @dev Check if a customer is whitelisted
     */
    function isCustomerWhiteListed(address customerAddress) external view override returns (bool) {
        return whitelist[customerAddress];
    }

    /**
     * @dev Get customer tier level
     */
    function customerTierLevel(address customerAddress) external view override returns (uint256) {
        return tierLevel[customerAddress];
    }

    /**
     * @dev Allow contract to receive ETH
     */
    receive() external payable {}
}
