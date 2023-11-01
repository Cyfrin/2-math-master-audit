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

// Context:
// We've split up the solmate sqrt function into two parts, the 2nd part is the same as the solday 2nd part.
// We are looking to see if the sqrt function of soladay is the same as

// Steps:
// 1. forge test --mt testSqrtFuzzSolmate
// We get a correct counterexample of 269599493631453065097309945537211393756002117862550147351608583595770249216

// 2. halmos --function test_strippedSqrt --solver-timeout-assertion 0
// Since the 2nd part of the solmate function is the same as the solday function (math masters) if we find a different output from the first part, it'll be what effects the 2nd part.
// We get an output like:
// [FAIL] test_strippedSqrt(uint256) (paths: 16/32, time: 34.85s, bounds: [])
// Counterexample:
//     p_randomNumber_uint256 = 0x0098e6c280000000000000000000000000000000000000000000000000000000 (270153399215703008567211276695681755578007329813283454683519097820145516544)
// Counterexample:
//     p_randomNumber_uint256 = 0x0000000000e82e8d0000000000c620c5c801880f0c0800010002000000000000 (95514068546010553524069246134821409238167173736538458818709815296)
// Counterexample:
//     p_randomNumber_uint256 = 0x000000000000000000c400590000000000000000000000000000885100000004 (18773200449252860965249471210541399248518453506219180036)
// Counterexample:
//     p_randomNumber_uint256 = 0x00000000000000000000000000cc048100000000000000000000000000000000 (4549744366069306962921659798542634575967813632)
// Counterexample:
//     p_randomNumber_uint256 = 0x0000000000000000000000000000000000ab000103821701a4000004838a9701 (887882843123342069450284981883148033)
// Counterexample:
//     p_randomNumber_uint256 = 0x0000000000000000000000000000000000000000009fa800133200004d200000 (193012564271016176024289280)
// Counterexample:
//     p_randomNumber_uint256 = 0x00000000000000000000000000000000000000000000000000efd19acd649800 (67502982234937344)
// Counterexample:
//     p_randomNumber_uint256 = 0x000000000000000000000000000000000000000000000000000000000099999c (10066332)
