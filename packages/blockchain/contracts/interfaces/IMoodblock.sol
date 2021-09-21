// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Moodblocks' NFTs Interface
interface IMoodblock {
    /// @dev Moodblock definition
    struct Moodblock {
        uint8 skin;
        uint8 face;
        uint8 eye;
        uint8 eyeColor;
        uint8 eyebrow;
        uint8 mouth;
        uint8 mark;
        uint8 background;
        // The timestamp from the block when this moodblock came into existence.
        uint64 createdAt;
    }

    /// @notice Returns the details associated with a given token ID.
    /// @dev Throws if the token ID is not valid.
    /// @param tokenId The ID of the token that represents the Moodblock.
    function details(uint256 tokenId) external view returns (Moodblock memory);
}