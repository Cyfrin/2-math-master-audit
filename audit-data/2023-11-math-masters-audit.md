# Findings

- [Findings](#findings)
  - [High](#high)
    - [\[H-1\] `MathMasters::sqrt` incorrectly checks the `lt` of a right shift, causing potentially incorrect sqrt values to be returned](#h-1-mathmasterssqrt-incorrectly-checks-the-lt-of-a-right-shift-causing-potentially-incorrect-sqrt-values-to-be-returned)
      - [Description](#description)
    - [\[H-2\] `MathMasters::mulWadUp` function does not revert as expected](#h-2-mathmastersmulwadup-function-does-not-revert-as-expected)
    - [\[H-3\] The `MathMasters::mulWadUp` function adds 1 erroneously to  `x` in specific situations, resulting in incorrect results](#h-3-the-mathmastersmulwadup-function-adds-1-erroneously-to--x-in-specific-situations-resulting-in-incorrect-results)
  - [Medium](#medium)
  - [Low](#low)
    - [\[L-1\] Solidity version `0.8.3` does not allow custom errors, breaking compliation.](#l-1-solidity-version-083-does-not-allow-custom-errors-breaking-compliation)
    - [\[L-2\] Wrong function selector for `MathMasters::MathMasters__FullMulDivFailed()` custom error](#l-2-wrong-function-selector-for-mathmastersmathmasters__fullmuldivfailed-custom-error)
  - [Info](#info)
    - [\[I-1\] Custom error codes are written to the solidity free memory pointer's position](#i-1-custom-error-codes-are-written-to-the-solidity-free-memory-pointers-position)


## High
### [H-1] `MathMasters::sqrt` incorrectly checks the `lt` of a right shift, causing potentially incorrect sqrt values to be returned 

#### Description 

The following is a snippet from the `MathMasters::sqrt` function. 

```javascript
            // 87112285931760246646623899502532662132735 == 0xffffffffffffffffffffffffffffffffff 
            let r := shl(7, lt(87112285931760246646623899502532662132735, x))
            // 4722366482869645213695 == 0xffffffffffffffffff
            r := or(r, shl(6, lt(4722366482869645213695, shr(r, x))))
            // 1099511627775 == 0xffffffffff
            r := or(r, shl(5, lt(1099511627775, shr(r, x))))
            // @audit this should be 16777215 / 0xffffff
            // Right now, it's 0xffff2a!
@>          r := or(r, shl(4, lt(16777002, shr(r, x))))
```

Here you can see multiple `lt` and `shl` operations being used to calculate the square root of a number. The math involved uses the [babalonian method](https://en.wikipedia.org/wiki/Methods_of_computing_square_roots) for calculating the square root here. 

### [H-2] `MathMasters::mulWadUp` function does not revert as expected

Corrected Function:
```diff
    function mulWadUp(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            // Equivalent to `require(y == 0 || x <= type(uint256).max / y)`.
+           if mul(y, gt(x, div(not(0), y))) {
-           if mul(y, gt(x, or(div(not(0), y), x))) {
                mstore(0x00, 0xbac65e5b) // `MulWadFailed()`.
                revert(0x1c, 0x04)
            }
            z := add(iszero(iszero(mod(mul(x, y), WAD))), div(mul(x, y), WAD))
        }
    }
```

### [H-3] The `MathMasters::mulWadUp` function adds 1 erroneously to  `x` in specific situations, resulting in incorrect results

```diff
function mulWadUp(uint256 x, uint256 y) internal pure returns (uint256 z) {
    /// @solidity memory-safe-assembly
    assembly {
        // Equivalent to `require(y == 0 || x <= type(uint256).max / y)`.
        if mul(y, gt(x, or(div(not(0), y), x))) {
            mstore(0x40, 0xbac65e5b) // `MathMasters__MulWadFailed()`.
            revert(0x1c, 0x04)
        }
-       if iszero(sub(div(add(z, x), y), 1)) { x := add(x, 1) }
        z := add(iszero(iszero(mod(mul(x, y), WAD))), div(mul(x, y), WAD))
    }
}
```

## Medium

## Low 
### [L-1] Solidity version `0.8.3` does not allow custom errors, breaking compliation. 

### [L-2] Wrong function selector for `MathMasters::MathMasters__FullMulDivFailed()` custom error
- The function selector of`MathMasters__FullMulDivFailed()` is `0x41672c55`, yet `0xae47f702` is being used. 

## Info

### [I-1] Custom error codes are written to the solidity free memory pointer's position 

It doesn't *do* anything... but like why are you doing that you masochist. 