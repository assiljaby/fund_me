// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";

contract DeployFundMe is Script {
    address price_feed_addr = 0x694AA1769357215DE4FAC081bf1f309aDC325306;

    function run() external returns (FundMe) {
        vm.startBroadcast();
        FundMe fundMe = new FundMe(price_feed_addr);
        vm.stopBroadcast();

        return fundMe;
    }
}
