# Findings

## High
### [H-1] 

## Medium

## Low 
### [L-1] Solidity version `0.8.3` does not allow custom errors, breaking compliation. 

## Info

### [I-1] Wrong function selector for `MathMasters::MathMasters__FullMulDivFailed()` custom error

- The function selector of`MathMasters__FullMulDivFailed()` is `0x41672c55`, yet `0xae47f702` is being used. 

### [I-2] Custom error codes are written to the solidity free memory pointer's position 

It doesn't *do* anything... but like why are you doing that you masochist. 