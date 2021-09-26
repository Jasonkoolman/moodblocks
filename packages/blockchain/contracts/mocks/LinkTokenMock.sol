// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./ERC677.sol";

contract LinkTokenMock is ERC20, ERC677 {
    constructor() ERC20("Chainlink", "LINK") {
        _mint(msg.sender, 100*10**18);
        _mint(address(0x0165878A594ca255338adfa4d48449f69242Eb8F), 100*10**18); // TODO: Refactor funding LINK to contract
    }
}
