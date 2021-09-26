// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Moodblocks' NFTs Interface
interface IMoodblock {
    /// @dev Moodblock definition
    struct Moodblock {
        uint8 background;
        uint8 eyes;
        uint8 mouth;
        uint8 mark;
        uint16 generation;
        uint64 created;
        address creator;
    }

    /// @notice Returns the details associated with a given token ID.
    /// @dev Throws if the token ID is not valid.
    /// @param tokenId The ID of the token that represents the Moodblock.
    function getMoodblock(uint256 tokenId) external view returns (Moodblock memory);
}