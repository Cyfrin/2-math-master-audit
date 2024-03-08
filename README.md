<p align="center">
<img src="./images/math-master.png" width="400" alt="math-master">
<br/>

# Math Master

*This codebase was inspired by the [solady](https://github.com/Vectorized/solady), [obront.eth](https://twitter.com/zachobront), and [solmate](https://github.com/transmissions11/solmate) codebases. Huge thanks to [karma](https://twitter.com/0xkarmacoma) for the help on FV with Halmos.*

- [Math Master](#math-master)
- [About](#about)
- [Getting Started](#getting-started)
  - [Requirements](#requirements)
  - [Quickstart](#quickstart)
- [Usage](#usage)
  - [Testing](#testing)
    - [Test Coverage](#test-coverage)
- [Audit Scope Details](#audit-scope-details)
  - [Compatibilities](#compatibilities)
- [Roles](#roles)
- [Known Issues](#known-issues)

# About

# Getting Started

## Requirements

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  - You'll know you did it right if you can run `git --version` and you see a response like `git version x.x.x`
- [foundry](https://getfoundry.sh/)
  - You'll know you did it right if you can run `forge --version` and you see a response like `forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)`
- [python3 & pip3](https://www.python.org/downloads/)
  - You'll know you did it right if you can run `python3 --version` and you see a response like `Python 3.x.x`
  - [Halmos](https://github.com/a16z/halmos)
    - To know you've installed it run `halmos --version` and you should see something like `halmos 0.1.0 (816e00b 2023-03-16T00:05:26.396218Z)
  - [certoraRun](https://docs.certora.com/en/latest/docs/user-guide/getting-started/install.html)
    - You'll know you did it right if you can run `certoraRun --version` and you get an output like: `certora-cli 6.3.1`

*Note: I like to install `certoraRun` and `halmos` using [pipx](https://github.com/pypa/pipx) instead of `pip`.*

## Quickstart

```
git clone https://github.com/Cyfrin/11-math-master-audit
cd 11-math-master-audit
make
```

# Usage

## Testing

```
forge test
```

### Test Coverage

```
forge coverage
```

and for coverage based testing:

```
forge coverage --report debug
```

# Audit Scope Details

- Commit Hash: 
- In Scope:

```

```

## Compatibilities

- Solc Version: xx
- Chain(s) to deploy contract to: 
  - Ethereum
- Tokens:
  - None

# Roles

XX

# Known Issues

None
