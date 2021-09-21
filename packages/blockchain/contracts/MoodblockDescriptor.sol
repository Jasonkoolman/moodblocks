// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'base64-sol/base64.sol';
import "./interfaces/IMoodblock.sol";
import "./interfaces/IMoodblockDescriptor.sol";
import "./libs/NFTDescriptor.sol";
import "./libs/DetailHelper.sol";

/// @title Describes Moodblock
/// @notice Produces a string containing the data URI for a JSON metadata string
contract MoodblockDescriptor is IMoodblockDescriptor {
    /// @dev Max value for defining probabilities
    uint256 internal constant MAX = 100000;

    uint256[] internal EYEBROW_ITEMS = [65000, 40000, 20000, 10000, 4000, 0];
    uint256[] internal MOUTH_ITEMS = [65000, 40000, 20000, 10000, 4000, 0];
    uint256[] internal MARK_ITEMS = [95000, 90000, 0];
    uint256[] internal EYE_ITEMS = [1000, 500, 100, 10, 0];

    function tokenURI(IMoodblock.Moodblock memory moodblock, uint256 tokenId) external pure override returns (string memory) {
        NFTDescriptor.SVGParams memory params = NFTDescriptor.SVGParams({
            skin: 1,
            face: 1,
            eye: 1,
            eyeColor: 1,
            eyebrow: 1,
            mouth: 1,
            mark: 1,
            background: 1
        });

        string memory image = svgToImageURI(NFTDescriptor.generateSVG(params));
        string memory name = "Moodblock";
        string memory description = "A random Moodblock.";
        string memory attributes = "[]";

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                name,
                                '", "description":"',
                                description,
                                '", "attributes":',
                                attributes,
                                ', "image": "',
                                image,
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    function svgToImageURI(string memory svg) private pure returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory base64EncodedSVG = Base64.encode(bytes(svg));
        return string(abi.encodePacked(baseURL, base64EncodedSVG));
    }

    /// @inheritdoc IMoodblockDescriptor
    function generateEyeId(uint256 tokenId, uint256 seed) external view override returns (uint8) {
        return DetailHelper.generate(MAX, seed, EYE_ITEMS, this.generateEyeId.selector, tokenId);
    }

    /// @inheritdoc IMoodblockDescriptor
    function generateEyebrowId(uint256 tokenId, uint256 seed) external view override returns (uint8) {
        return DetailHelper.generate(MAX, seed, EYEBROW_ITEMS, this.generateEyebrowId.selector, tokenId);
    }

    /// @inheritdoc IMoodblockDescriptor
    function generateMouthId(uint256 tokenId, uint256 seed) external view override returns (uint8) {
        return DetailHelper.generate(MAX, seed, MOUTH_ITEMS, this.generateMouthId.selector, tokenId);
    }

    /// @inheritdoc IMoodblockDescriptor
    function generateMarkId(uint256 tokenId, uint256 seed) external view override returns (uint8) {
        return DetailHelper.generate(MAX, seed, MARK_ITEMS, this.generateMarkId.selector, tokenId);
    }
}