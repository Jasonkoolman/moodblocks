// SPDX-License-Identifier: MIT

/// @title A library used to construct ERC721 token URIs and SVG images

pragma solidity ^0.8.0;

import "./details/BackgroundDetail.sol";
import "./details/EyesDetail.sol";
import "./details/MouthDetail.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

library NFTDescriptor {
    /// @dev NFT definition
    struct NFTParams {
        EyesDetail.Eyes eyes;
        MouthDetail.Mouth mouth;
        BackgroundDetail.Background background;
        address creator;
        uint256 created;
        uint16 generation;
    }

    /// @dev Combine all the SVGs to generate the final image
    function generateImage(NFTParams memory params) internal view returns (string memory) {
        return string(
            abi.encodePacked(
                '<svg width="420" height="420" viewBox="0 0 420 420" xmlns="http://www.w3.org/2000/svg">',
                    BackgroundDetail.background(params.background.fill),
                    getDetailSVG(address(EyesDetail), params.eyes.selector),
                    getDetailSVG(address(MouthDetail), params.mouth.selector),
                '</svg>'
            )
        );
    }

    /// @dev Generates JSON metadata name
    function generateName(uint256 tokenId) internal pure returns (string memory) {
        return string(
            abi.encodePacked(
                "Moodblock ", Strings.toString(tokenId)
            )
        );
    }

    /// @dev Generates JSON metadata description
    function generateDescription(NFTParams memory params) internal pure returns (string memory) {
        bool original = params.generation == 1;
        return string(
            abi.encodePacked(
                "Minted by ", Strings.toHexString(uint256(uint160(params.creator))), ".",
                (original ? " A first of its kind!" : "")
            )
        );
    }

    /// @dev Generates JSON metadata attributes
    function generateAttributes(NFTParams memory params) internal pure returns (string memory) {
        return string(
            abi.encodePacked(
                "[",
                    getJSONAttribute("Eyes", params.eyes.name, false),
                    getJSONAttribute("Mouth", params.mouth.name, false),
                    getJSONAttribute("Background", params.background.name, false),
                    getJSONAttribute("Generation", Strings.toString(params.generation), false),
                    getJSONAttribute("Created", Strings.toString(params.created), true),
                "]"
            )
        );
    }

    /// @dev Call the library item function.
    function getDetailSVG(address lib, string memory selector) private view returns (string memory) {
        (bool success, bytes memory data) = lib.staticcall(
            abi.encodeWithSignature(string(abi.encodePacked(selector, "()")))
        );
        require(success, "DetailHelper: Failed to call detail library");
        return abi.decode(data, (string));
    }

    /// @dev Get the JSON attribute as
    ///  {
    ///      "name": "Eyes",
    ///      "value": "Googly"
    ///  }
    function getJSONAttribute(
        string memory name,
        string memory value,
        bool last
    ) private pure returns (string memory json) {
        return string(abi.encodePacked('{"name": "', name, '", "value": "', value, '"}', last ? "" : ","));
    }
}