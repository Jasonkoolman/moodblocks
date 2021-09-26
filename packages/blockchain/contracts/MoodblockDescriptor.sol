// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'base64-sol/base64.sol';
import "./interfaces/IMoodblock.sol";
import "./interfaces/IMoodblockDescriptor.sol";
import "./libs/NFTDescriptor.sol";
import "./libs/DetailHelper.sol";
import "./libs/details/BackgroundDetail.sol";
import "./libs/details/EyesDetail.sol";
import "./libs/details/MouthDetail.sol";

import "@openzeppelin/contracts/utils/math/SafeCast.sol";

/// @title Describes Moodblock
/// @notice Produces a string containing the data URI for a JSON metadata string
contract MoodblockDescriptor is IMoodblockDescriptor {
    uint256[] internal MARK_ITEMS = [0];

    function tokenURI(IMoodblock.Moodblock memory moodblock, uint256 tokenId) external view override returns (string memory) {
        NFTDescriptor.NFTParams memory params = toNFTParams(moodblock);
        string memory name = NFTDescriptor.generateName(tokenId);
        string memory image = toImageURI(NFTDescriptor.generateImage(params));
        string memory description = NFTDescriptor.generateDescription(params);
        string memory attributes = NFTDescriptor.generateAttributes(params);

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

    // @dev Converts Moodblock to NFTParams
    function toNFTParams(IMoodblock.Moodblock memory moodblock) private pure returns (NFTDescriptor.NFTParams memory params) {
        return NFTDescriptor.NFTParams({
            eyes: EyesDetail.getEyes(moodblock.eyes),
            mouth: MouthDetail.getMouth(moodblock.mouth),
            background: BackgroundDetail.getBackground(moodblock.background),
            creator: moodblock.creator,
            created: moodblock.created,
            generation: moodblock.generation
        });
    }

    /// @dev Converts SVG to a Data URI
    function toImageURI(string memory svg) private pure returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory base64EncodedSVG = Base64.encode(bytes(svg));
        return string(abi.encodePacked(baseURL, base64EncodedSVG));
    }

    /// @inheritdoc IMoodblockDescriptor
    function generateBackgroundId(uint256 tokenId, uint256 seed) external view override returns (uint8) {
        return SafeCast.toUint8(
            DetailHelper.generateRandom(BackgroundDetail.COUNT, seed, tokenId, this.generateBackgroundId.selector)
        );
    }

    /// @inheritdoc IMoodblockDescriptor
    function generateEyesId(uint256 tokenId, uint256 seed) external view override returns (uint8) {
        return SafeCast.toUint8(
            DetailHelper.generateRandom(EyesDetail.COUNT, seed, tokenId, this.generateEyesId.selector)
        );
    }

    /// @inheritdoc IMoodblockDescriptor
    function generateMouthId(uint256 tokenId, uint256 seed) external view override returns (uint8) {
        return SafeCast.toUint8(
            DetailHelper.generateRandom(MouthDetail.COUNT, seed, tokenId, this.generateMouthId.selector)
        );
    }

    /// @inheritdoc IMoodblockDescriptor
    function generateMarkId(uint256 tokenId, uint256 seed) external view override returns (uint8) {
        return DetailHelper.generate(100000, seed, MARK_ITEMS, this.generateMarkId.selector, tokenId);
    }
}