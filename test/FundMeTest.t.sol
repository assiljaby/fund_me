// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/deployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address immutable USER = makeAddr("user"); // makes a new sender address
    uint256 constant SEND_AMMOUNT = 1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE); // updates the test user's balance
    }

    function testMinimunDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testIsOwner() public view {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersionIsFour() public view {
        assertEq(fundMe.getVersion(), 4);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert();
        fundMe.fund();
    }

    modifier funded() {
        vm.prank(USER); // This func tests the sender of the transaction
        fundMe.fund{value: SEND_AMMOUNT}();

        _;
    }

    function testFundUpdatesFundersMapping() public funded {
        assertEq(fundMe.getAddressToAmmountFunded(USER), SEND_AMMOUNT);
    }

    function testFundUpdatesFundersArray() public funded {
        assertEq(fundMe.getFunders(0), USER);
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }

    function testWithdrawWithOwner() public funded {
        uint256 ownerStartingBalance = fundMe.getOwner().balance;
        uint256 fundMeStartingBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 ownerCurrentBalance = fundMe.getOwner().balance;
        uint256 fundMeCurrentBalance = address(fundMe).balance;
        assertEq(fundMeCurrentBalance, 0);
        assertEq(ownerCurrentBalance, ownerStartingBalance + fundMeStartingBalance);
    }
}
