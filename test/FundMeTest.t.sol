// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address price_feed_addr = 0x694AA1769357215DE4FAC081bf1f309aDC325306;

    function setUp() external {
        fundMe = new FundMe(price_feed_addr);
    }

    function testMinimunDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testIsOwner() public view {
        assertEq(fundMe.i_owner(), address(this));
    }

    function testPriceFeedVersionIsFour() public view {
        assertEq(fundMe.getVersion(), 4);
    }
}
