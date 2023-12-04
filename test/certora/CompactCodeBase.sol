// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {MathMasters} from "../../src/MathMasters.sol";

contract CompactCodeBase {
    function mathMastersSqrt(uint256 x) external pure returns (uint256) {
        return MathMasters.sqrt(x);
    }

    // Based on uniswap
    function uniSqrt(uint256 y) external pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
}
