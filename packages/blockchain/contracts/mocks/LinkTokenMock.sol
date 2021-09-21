// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./ERC677.sol";

contract LinkTokenMock is ERC20, ERC677 {
    constructor() ERC20("Chainlink", "LINK") {
        _mint(msg.sender, 100*10**18);
        _mint(address(0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9), 100*10**18); // TODO: Refactor funding LINK to contract
    }
}
