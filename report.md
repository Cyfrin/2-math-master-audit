# Table of Contents

- [Low Issues](#low-issues)
  - [L-1: Solidity pragma should be specific, not wide](#L-1)


# Low Issues

<a name="L-1"></a>
## L-1: Solidity pragma should be specific, not wide

Consider using a specific version of Solidity in your contracts instead of a wide version. For example, instead of `pragma solidity ^0.8.0;`, use `pragma solidity 0.8.0;`

- Found in src/MathMasters.sol: 132:23:0


