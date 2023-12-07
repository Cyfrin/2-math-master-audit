// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {MathMasters} from "../../src/MathMasters.sol";

contract CompactCodeBase {
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

    function mathMastersSqrt(uint256 x) external pure returns (uint256) {
        return MathMasters.sqrt(x);
    }

    function solmateSqrtStripped(uint256 x) external pure returns (uint256 z) {
        assembly {
            let y := x

            z := 181
            if iszero(lt(y, 0x10000000000000000000000000000000000)) {
                y := shr(128, y)
                z := shl(64, z)
            }
            if iszero(lt(y, 0x1000000000000000000)) {
                y := shr(64, y)
                z := shl(32, z)
            }
            if iszero(lt(y, 0x10000000000)) {
                y := shr(32, y)
                z := shl(16, z)
            }
            if iszero(lt(y, 0x1000000)) {
                y := shr(16, y)
                z := shl(8, z)
            }

            z := shr(18, mul(z, add(y, 65536)))
        }
    }

    function mathMastersSqrtStripped(uint256 x) external pure returns (uint256 z) {
        assembly {
            // z := 0xb5 // 181
            z := 181

            let r := shl(0x7, lt(0xffffffffffffffffffffffffffffffffff, x))
            r := or(r, shl(0x6, lt(0xffffffffffffffffff, shr(r, x))))
            r := or(r, shl(0x5, lt(0xffffffffff, shr(r, x))))
            // Correct: 16777215 0xffffff
            r := or(r, shl(0x4, lt(16777002, shr(r, x))))
            z := shl(shr(0x1, r), z)

            z := shr(0x12, mul(z, add(shr(r, x), 0x10000)))
        }
    }
}
