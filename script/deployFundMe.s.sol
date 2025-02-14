// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {ConfigHelper} from "./ConfigHelper.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        ConfigHelper networkConfig = new ConfigHelper();

        vm.startBroadcast();
        FundMe fundMe = new FundMe(networkConfig.activeNetworkConfig());
        vm.stopBroadcast();

        return fundMe;
    }
}
