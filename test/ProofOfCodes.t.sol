// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import {Base_Test, console2} from "./Base_Test.t.sol";
import {MathMasters} from "src/MathMasters.sol";
import {SymTest} from "halmos-cheatcodes/SymTest.sol";

// Solution inspired by zobront
// https://github.com/zobront/halmos-solady/blob/main/src/functions/Sqrt.sol
contract ProofOfCodes is Base_Test, SymTest {
    // halmos --function check_testMulWadFuzz --solver-timeout-assertion 0
    // We have to use revert instead of return for halmos
    function check_testMulWadFuzz(uint256 x, uint256 y) public pure {
        // Ignore cases where x * y overflows.
        unchecked {
            if (x != 0 && (x * y) / x != y) revert();
        }
        assert(MathMasters.mulWad(x, y) == (x * y) / 1e18);
    }

    // halmos --function check_testMulWadUpFuzz --solver-timeout-assertion 0
    function check_testMulWadUpFuzz(uint256 x, uint256 y) public pure {
        if (x == 0 || y == 0 || y <= type(uint256).max / x) {
            uint256 result = MathMasters.mulWadUp(x, y);
            uint256 expected = x * y == 0 ? 0 : (x * y - 1) / 1e18 + 1;
            assert(result == expected);
        }
    }

    // halmos --function check_sqrt --solver-timeout-assertion 0
    // We run into the path explosion problem!!!
    // Is there another way we can compare?
    function check_sqrt(uint256 randomNumber) public pure {
        assert(uniSqrt(randomNumber) == MathMasters.sqrt(randomNumber));
    }

    // halmos --function test_strippedSqrt --solver-timeout-assertion 0
    function test_strippedSqrt(uint256 randomNumber) public pure {
        assert(_solmateSqrtStripped(randomNumber) == _mathMastersSqrtStripped(randomNumber));
    }

    // function testHalmosCaseOutput() public {
    //     uint256 counterExampleOne = 269599493631453065097309945537211393756002117862550147351608583595770249216;
    //     uint256 counterExampleTwo = 1329211754011600485608088531189675272;
    //     uint256 counterExampleThree = 309483036037743857337630720;
    //     uint256 counterExampleFour = 72057108706623488;

    //     assertEq(MathMasters.sqrt(counterExampleOne), solmateSqrt(counterExampleOne));
    //     assertEq(MathMasters.sqrt(counterExampleOne), uniSqrt(counterExampleOne));

    //     assertEq(MathMasters.sqrt(counterExampleTwo), solmateSqrt(counterExampleTwo));
    //     assertEq(MathMasters.sqrt(counterExampleTwo), uniSqrt(counterExampleTwo));

    //     assertEq(MathMasters.sqrt(counterExampleThree), solmateSqrt(counterExampleThree));
    //     assertEq(MathMasters.sqrt(counterExampleThree), uniSqrt(counterExampleThree));

    //     assertEq(MathMasters.sqrt(counterExampleFour), solmateSqrt(counterExampleFour));
    //     assertEq(MathMasters.sqrt(counterExampleFour), uniSqrt(counterExampleFour));
    // }

    // // Does fuzzing catch it?
    // // Uncomment this to find out!
    // function testStrippedSqrt(uint256 randomNumber) public pure {
    //     assert(_solmateSqrtStripped(randomNumber) == _mathMastersSqrtStripped(randomNumber));
    // }

    /*//////////////////////////////////////////////////////////////
                            HELPER FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    // The full Solmate function, with the final part removed because it's identical in both implementations.
    function _solmateSqrtStripped(uint256 x) internal pure returns (uint256 z) {
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

    function _mathMastersSqrtStripped(uint256 x) internal pure returns (uint256 z) {
        assembly {
            z := 0xb5

            let r := shl(0x7, lt(0xffffffffffffffffffffffffffffffffff, x))
            r := or(r, shl(0x6, lt(0xffffffffffffffffff, shr(r, x))))
            r := or(r, shl(0x5, lt(0xffffffffff, shr(r, x))))
            r := or(r, shl(0x4, lt(10000000, shr(r, x))))
            z := shl(shr(0x1, r), z)

            z := shr(0x12, mul(z, add(shr(r, x), 0x10000)))
        }
    }

    // The final part of the original functions, which has been abstracted out for clarity.
    function _secondHalfOfSqrtFunction(uint256 x, uint256 z) internal pure returns (uint256 ret) {
        assembly {
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))

            ret := sub(z, lt(div(x, z), z))
        }
    }
}

// Example of a true counter example:
// 269599493631453065097309945537211393756002117862550147351608583595770249216
