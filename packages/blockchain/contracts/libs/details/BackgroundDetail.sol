// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "base64-sol/base64.sol";

/// @title Background SVG generator
library BackgroundDetail {
    uint256 public constant COUNT = 19;

    struct Background {
        string name;
        string fill;
    }

    /// @notice Returns a `Background` by ID
    function getBackground(uint8 id) public pure returns (Background memory) {
        require(id > 0 && id <= COUNT, "BackgroundDetail: Invalid ID supplied");
        return getAll()[id - 1];
    }

    /// @notice Returns all backgrounds
    function getAll() public pure returns (Background[COUNT] memory) {
        return [
            Background({ name: "Red", fill: "F64C49" }),
            Background({ name: "Pink", fill: "EC407A" }),
            Background({ name: "Purple", fill: "BA68C8" }),
            Background({ name: "Deep Purple", fill: "7E57C2" }),
            Background({ name: "Indigo", fill: "3F51B5" }),
            Background({ name: "Blue", fill: "2196F3" }),
            Background({ name: "Light Blue", fill: "29B6F6" }),
            Background({ name: "Cyan", fill: "26C6DA" }),
            Background({ name: "Teal", fill: "4DB6AC" }),
            Background({ name: "Green", fill: "66BB6A"}),
            Background({ name: "Light Green", fill: "8BC34A" }),
            Background({ name: "Lime", fill: "CDDC39" }),
            Background({ name: "Yellow", fill: "FDD835" }),
            Background({ name: "Amber", fill: "FFB300" }),
            Background({ name: "Orange", fill: "FB8C00" }),
            Background({ name: "Deep Orange", fill: "FB8C00" }),
            Background({ name: "Brown", fill: "8D6E63" }),
            Background({ name: "Grey", fill: "BDBDBD" }),
            Background({ name: "Blue Grey", fill: "78909C" })
        ];
    }

    /// @dev The base SVG for the background
    function background(string memory fill) public pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    '<g class="background">',
                        '<rect width="420" height="420" fill="#', fill, '"/>',
                        '<rect width="420" height="420" fill="url(#glow)" fill-opacity="0.1"/>',
                        '<defs>',
                            '<linearGradient id="glow" x1="210" y1="0" x2="210" y2="420" gradientUnits="userSpaceOnUse">',
                                '<stop stop-color="white"/>',
                                '<stop offset="1" stop-color="white" stop-opacity="0"/>',
                            '</linearGradient>',
                        '</defs>',
                    '</g>'
                )
            );
    }
}