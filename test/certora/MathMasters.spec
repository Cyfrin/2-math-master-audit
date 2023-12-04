/*
 * Certora Formal Verification Spec of the SQRT function
 */ 
using CompactCodeBase as math_masters; 

methods {
    function mathMastersSqrt(uint256) external returns uint256 envfree;
    function uniSqrt(uint256) external returns uint256 envfree;
}

rule uniSqrtMatchesMathMastersSqrt(uint256 x) {
    assert(math_masters.mathMastersSqrt(x) == math_masters.uniSqrt(x));
}
