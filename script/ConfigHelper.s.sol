// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";

contract ConfigHelper is Script {
    struct NetworkConfig {
        address price_feed_addr;
    }

    NetworkConfig public activeNetworkConfig;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepolioConfig();
        } else {
            activeNetworkConfig = getAnvilConfig();
        }
    }

    function getSepolioConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({price_feed_addr: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
    }

    // TODO: add mock pricefeed config
    function getAnvilConfig() public pure returns (NetworkConfig memory) {}
}
