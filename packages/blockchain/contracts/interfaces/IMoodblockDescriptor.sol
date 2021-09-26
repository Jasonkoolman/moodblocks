// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IMoodblock.sol";

/// @title Describes Moodblock via URI
interface IMoodblockDescriptor {
    /// @notice Produces the URI describing a particular Moodblock (token id)
    /// @dev Note This URI may be a data: URI with the JSON contents directly inlined
    /// @return The URI of the ERC721-compliant metadata
    function tokenURI(IMoodblock.Moodblock memory moodblock, uint256 tokenId) external view returns (string memory);

    /// @notice Generate randomly an ID for the eyes.
    /// @param tokenId The current tokenId.
    /// @param seed Used for the initialization of the number generator.
    /// @return The eye item id.
    function generateEyesId(uint256 tokenId, uint256 seed) external view returns (uint8);

    /// @notice Generate randomly an ID for the mouth item.
    /// @param tokenId The current tokenId.
    /// @param seed Used for the initialization of the number generator.
    /// @return The mouth item id.
    function generateMouthId(uint256 tokenId, uint256 seed) external view returns (uint8);

    /// @notice Generate randomly an ID for the mark item.
    /// @param tokenId The current tokenId.
    /// @param seed Used for the initialization of the number generator.
    /// @return The mark item id.
    function generateMarkId(uint256 tokenId, uint256 seed) external view returns (uint8);

    /// @notice Generate randomly an ID for the background.
    /// @param tokenId The current tokenId.
    /// @param seed Used for the initialization of the number generator.
    /// @return The background item id.
    function generateBackgroundId(uint256 tokenId, uint256 seed) external view returns (uint8);
}