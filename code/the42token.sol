// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract The42Token is ERC20 {
    uint256 public constant INIT_SUPP = 1337 * 10**18;

    constructor() ERC20("The42Token", "T42") {
        _mint(msg.sender, INIT_SUPP);    
    }
}
