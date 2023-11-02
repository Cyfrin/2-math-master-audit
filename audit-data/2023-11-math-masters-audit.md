# Findings

## High
### [H-1] `MathMasters::sqrt` incorrectly checks the `lt` of a right shift

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

## Medium

## Low 
### [L-1] Solidity version `0.8.3` does not allow custom errors, breaking compliation. 

## Info

### [I-1] Wrong function selector for `MathMasters::MathMasters__FullMulDivFailed()` custom error

- The function selector of`MathMasters__FullMulDivFailed()` is `0x41672c55`, yet `0xae47f702` is being used. 

### [I-2] Custom error codes are written to the solidity free memory pointer's position 

It doesn't *do* anything... but like why are you doing that you masochist. 