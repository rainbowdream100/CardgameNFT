//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";

contract NusToken is ERC20PresetMinterPauser {

    constructor() ERC20PresetMinterPauser("NUS FT5004 Token", "NUS") {
    }

}