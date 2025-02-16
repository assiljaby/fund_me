// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    mapping(address => uint256) internal s_addressToAmountFunded;
    address[] internal s_funders;

    address internal immutable i_owner;
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18;

    AggregatorV3Interface internal s_priceFeed;

    constructor(address _price_feed_addr) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(_price_feed_addr);
    }

    function fund() public payable {
        require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "You need to spend more ETH!");
        s_addressToAmountFunded[msg.sender] += msg.value;
        s_funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    modifier onlyOwner() {
        require(msg.sender == i_owner);

        _;
    }

    function withdraw() public onlyOwner {
        /**
         * By assigning the lenght of s_funders to a local var
         * we will spend less gas by avoiding reading from storage
         * on each loop iteration
         */
        uint256 fundersLength = s_funders.length;

        for (uint256 funderIndex = 0; funderIndex < fundersLength; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        // drain funds
        s_funders = new address[](0);

        // cash out
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }

    /**
     * view funcs
     */
    function getAddressToAmmountFunded(address _fundingAddress) external view returns (uint256) {
        return s_addressToAmountFunded[_fundingAddress];
    }

    function getFunders(uint256 idx) external view returns (address) {
        return s_funders[idx];
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }
}
