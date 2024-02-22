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

    // From CodeHawks participant!
    // https://www.codehawks.com/report/clrp8xvh70001dq1os4gaqbv5#H-02
    function testMulWadUpFuzzOverflow(uint256 x, uint256 y) public {
        // Precondition: x * y > uint256 max
        // After reviewing the code, I know it will be enough x to be a small number greater than one, therefore x is limited to be lower than 10
        vm.assume(x > 1 && x < 10);
        vm.assume(y > type(uint256).max / x);

        vm.expectRevert();
        MathMasters.mulWadUp(x, y);
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
    // Ahh! This is too complicated for our measly computer!
    // Is there another way we can compare?
    function check_sqrt(uint256 randomNumber) public pure {
        assert(uniSqrt(randomNumber) == MathMasters.sqrt(randomNumber));
    }

    // function testCheckSqrtUnit() public pure {
    //     uint256 randomNumber = 0xffff2b00000000000000000000000000000000000000000000000000000000;
    //     assert(uniSqrt(randomNumber) == MathMasters.sqrt(randomNumber));
    // }

    // function testCheckSqrtStrippedUnit() public {
    //     uint256 randomNumber = 0xffff2b00000000000000000000000000000000000000000000000000000000;
    //     assertEq(_solmateSqrtStripped(randomNumber), _mathMastersSqrtStripped(randomNumber));
    // }

    // halmos --function test_strippedSqrt --solver-timeout-assertion 0
    function test_strippedSqrt(uint256 randomNumber) public pure {
        uint256 z = _mathMastersSqrtStripped(randomNumber);
        if (z != _solmateSqrtStripped(randomNumber)) {
            assert(_secondHalfOfSqrtFunction(randomNumber, z) == uniSqrt(randomNumber));
        }
    }

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
