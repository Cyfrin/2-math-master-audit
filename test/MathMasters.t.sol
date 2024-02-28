// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.3;

import {Base_Test, console2} from "./Base_Test.t.sol";
import {MathMasters} from "src/MathMasters.sol";

contract MathMastersTest is Base_Test {
    function testMulWad() public {
        assertEq(MathMasters.mulWad(2.5e18, 0.5e18), 1.25e18);
        assertEq(MathMasters.mulWad(3e18, 1e18), 3e18);
        assertEq(MathMasters.mulWad(369, 271), 0);
    }

    // function testMulWadRevert() public {
    //     MathMasters.mulWad(type(uint256).max, type(uint256).max);
    // }

    function testCertoraOutput() public {
        uint256 x = 0;
        assertEq(MathMasters.sqrt(x), uniSqrt(x));
    }

    function testMulWadFuzz(uint256 x, uint256 y) public pure {
        // Ignore cases where x * y overflows.
        unchecked {
            if (x != 0 && (x * y) / x != y) return;
        }
        assert(MathMasters.mulWad(x, y) == (x * y) / 1e18);
    }

    function testMulWadUp() public {
        assertEq(MathMasters.mulWadUp(2.5e18, 0.5e18), 1.25e18);
        assertEq(MathMasters.mulWadUp(3e18, 1e18), 3e18);
        assertEq(MathMasters.mulWadUp(369, 271), 1);
    }

    function testMulWadUpFuzz(uint256 x, uint256 y) public {
        // We want to skip the case where x * y would overflow.
        // Since Solidity 0.8.0 checks for overflows by default,
        // we cannot just multiply x and y as this could revert.
        // Instead, we can ensure x or y is 0, or
        // that y is less than or equal to the maximum uint256 value divided by x
        if (x == 0 || y == 0 || y <= type(uint256).max / x) {
            uint256 result = MathMasters.mulWadUp(x, y);
            uint256 expected = x * y == 0 ? 0 : (x * y - 1) / 1e18 + 1;
            assertEq(result, expected);
        }
        // If the conditions for x and y are such that x * y would overflow,
        // this function will simply not perform the assertion.
        // In a testing context, you might want to handle this case differently,
        // depending on whether you want to consider such an overflow case as passing or failing.
    }

    function testSqrt() public {
        assertEq(MathMasters.sqrt(0), 0);
        assertEq(MathMasters.sqrt(1), 1);
        assertEq(MathMasters.sqrt(2704), 52);
        assertEq(MathMasters.sqrt(110889), 333);
        assertEq(MathMasters.sqrt(32239684), 5678);
        assertEq(MathMasters.sqrt(type(uint256).max), 340282366920938463463374607431768211455);
    }

    function testSqrtFuzzUni(uint256 x) public pure {
        assert(MathMasters.sqrt(x) == uniSqrt(x));
    }

    function testSqrtFuzzSolmate(uint256 x) public pure {
        assert(MathMasters.sqrt(x) == solmateSqrt(x));
    }
}

// 269599493631453065097309945537211393756002117862550147351608583595770249216
