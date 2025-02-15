// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mock/MockV3Aggregator.sol";

contract ConfigHelper is Script {
    uint8 constant DECIMALS = 8;
    int256 constant INITIAL_VALUE = 2000e8;
    uint256 constant SEPOLIA_CHAIN_ID = 11155111;

    struct NetworkConfig {
        address price_feed_addr;
    }

    NetworkConfig public activeNetworkConfig;

    constructor() {
        if (block.chainid == SEPOLIA_CHAIN_ID) {
            activeNetworkConfig = getSepolioConfig();
        } else {
            activeNetworkConfig = getAnvilConfig();
        }
    }

    function getSepolioConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({price_feed_addr: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
    }

    // TODO: add mock pricefeed config
    function getAnvilConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.price_feed_addr != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockPricefeed = new MockV3Aggregator(DECIMALS, INITIAL_VALUE);
        vm.stopBroadcast();

        return NetworkConfig({price_feed_addr: address(mockPricefeed)});
    }
}
