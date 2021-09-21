// SPDX-License-Identifier: MIT

/// @title A library used to construct ERC721 token URIs and SVG images

pragma solidity ^0.8.0;

library NFTDescriptor {
    struct SVGParams {
        uint8 skin;
        uint8 face;
        uint8 eye;
        uint8 eyeColor;
        uint8 eyebrow;
        uint8 mouth;
        uint8 mark;
        uint8 background;
    }

    function generateSVG(SVGParams memory params) internal pure returns (string memory) {
        string memory children = string(
            abi.encodePacked(
                generateBackground()
            )
        );

        return wrapSVGElement(children);
    }

    function generateBackground() private pure returns (string memory) {
        return '<rect width="420" height="420" fill="#F8DBFB"/>';
    }

    /// @dev generate SVG header
    function wrapSVGElement(string memory children) private pure returns (string memory) {
        return string(
            abi.encodePacked(
                '<svg width="420" height="420" viewBox="0 0 420 420" fill="none" xmlns="http://www.w3.org/2000/svg">',
                children,
                '</svg>'
            )
        );
    }

    /// @dev Get the json attribute as
    ///    {
    ///      "name": "Skin",
    ///      "value": "Human"
    ///    }
    function getJsonAttribute(
        string memory name,
        string memory value,
        bool end
    ) private pure returns (string memory json) {
        return string(abi.encodePacked('{ "name" : "', name, '", "value" : "', value, '" }', end ? "" : ","));
    }
}