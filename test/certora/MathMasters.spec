/*
 * Certora Formal Verification Spec of the SQRT function
 */ 
using CompactCodeBase as math_masters; 

methods {
    function mathMastersSqrt(uint256) external returns uint256 envfree;
    function uniSqrt(uint256) external returns uint256 envfree;
}
// methods {
//     function mathMastersSqrtStripped(uint256) external returns uint256 envfree;
//     function solmateSqrtStripped(uint256) external returns uint256 envfree;
// }


rule uniSqrtMatchesMathMastersSqrt(uint256 x) {
    assert(math_masters.mathMastersSqrt(x) == math_masters.uniSqrt(x));
}

// rule solmateSqrtMatchesMathMastersSqrt(uint256 x) {
//     assert(math_masters.mathMastersSqrtStripped(x) == math_masters.solmateSqrtStripped(x));
// }
