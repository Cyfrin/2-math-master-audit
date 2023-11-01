// SPDX-License-Identifier: MIT
// @notice We intentionally want to leave this as floating point so others can use it as a library.
pragma solidity ^0.8.3;

/// @notice Arithmetic library with operations for fixed-point numbers.
/// @notice People taking my course: Don't cheat and look at the answers!
/// @author Math Masters
/// @author Modified from Solady (https://github.com/vectorized/solady/blob/main/src/utils/FixedPointMathLib.sol)
/// @author Modified from Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/FixedPointMathLib.sol)
library MathMasters {
    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/
    error MathMasters__FactorialOverflow();
    error MathMasters__MulWadFailed();
    error MathMasters__DivWadFailed();
    error MathMasters__FullMulDivFailed();

    /*//////////////////////////////////////////////////////////////
    /*                         CONSTANTS                          */
    //////////////////////////////////////////////////////////////*/
    /// @dev The scalar of ETH and most ERC20s.
    uint256 internal constant WAD = 1e18; // WAD just means 18 decimal places

    // History lesson: WAD, RAY, and RAD were introduced in MakerDAO's original DAI system. The names sort of stuck.
    // wad: fixed point decimal with 18 decimals (for basic quantities, e.g. balances)
    // ray: fixed point decimal with 27 decimals (for precise quantites, e.g. ratios)
    // rad: fixed point decimal with 45 decimals (result of integer multiplication with a wad and a ray)

    /*//////////////////////////////////////////////////////////////
    /*              SIMPLIFIED FIXED POINT OPERATIONS             */
    //////////////////////////////////////////////////////////////*/

    /// @dev Equivalent to `(x * y) / WAD` rounded down.
    function mulWad(uint256 x, uint256 y) internal pure returns (uint256 z) {
        // @solidity memory-safe-assembly
        assembly {
            // Equivalent to `require(y == 0 || x <= type(uint256).max / y)`.
            if mul(y, gt(x, div(not(0), y))) {
                mstore(0x40, 0xbac65e5b) // `MathMasters__MulWadFailed()`.
                revert(0x1c, 0x04)
            }
            z := div(mul(x, y), WAD)
        }
    }

    /// @dev Equivalent to `(x * y) / WAD` rounded up.
    function mulWadUp(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            // Equivalent to `require(y == 0 || x <= type(uint256).max / y)`.
            if mul(y, gt(x, or(div(not(0), y), x))) {
                mstore(0x40, 0xbac65e5b) // `MathMasters__MulWadFailed()`.
                revert(0x1c, 0x04)
            }
            z := add(iszero(iszero(mod(mul(x, y), WAD))), div(mul(x, y), WAD))
        }
    }

    /// @dev Equivalent to `(x * WAD) / y` rounded down.
    function divWad(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            // Don't want to divide by 0
            if iszero(y) {
                mstore(0x40, 0xd5c00fba) // `MathMasters__DivWadFailed()`.
                revert(0x1c, 0x04)
            }
            // Multiply before divide
            z := div(mul(x, WAD), y)
        }
    }

    /// @dev Equivalent to `(x * WAD) / y` rounded up.
    function divWadUp(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            // Don't want to divide by 0
            if iszero(y) {
                mstore(0x40, 0xd5c00fba) // `MathMasters__DivWadFailed()`.
                revert(0x1c, 0x04)
            }
            z := add(iszero(iszero(mod(mul(x, WAD), y))), div(mul(x, WAD), y))
        }
    }

    /*//////////////////////////////////////////////////////////////
    /*                  GENERAL NUMBER UTILITIES                  */
    //////////////////////////////////////////////////////////////*/

    /// @dev Returns the square root of `x`.
    function sqrt(uint256 x) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := 181

            // This segment is to get a reasonable initial estimate for the Babylonian method. With a bad
            // start, the correct # of bits increases ~linearly each iteration instead of ~quadratically.
            let r := shl(7, lt(87112285931760246646623899502532662132735, x))
            r := or(r, shl(6, lt(4722366482869645213695, shr(r, x))))
            r := or(r, shl(5, lt(1099511627775, shr(r, x))))
            r := or(r, shl(4, lt(10000000, shr(r, x))))
            z := shl(shr(1, r), z)

            // There is no overflow risk here since `y < 2**136` after the first branch above.
            z := shr(18, mul(z, add(shr(r, x), 65536))) // A `mul()` is saved from starting `z` at 181.

            // Given the worst case multiplicative error of 2.84 above, 7 iterations should be enough.
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))

            // If `x+1` is a perfect square, the Babylonian method cycles between
            // `floor(sqrt(x))` and `ceil(sqrt(x))`. This statement ensures we return floor.
            // See: https://en.wikipedia.org/wiki/Integer_square_root#Using_only_integer_division
            z := sub(z, lt(div(x, z), z))
        }
    }
}
