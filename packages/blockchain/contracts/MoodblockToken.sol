// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';

contract MoodblockToken is Ownable, ERC721 {
    /// @dev The Created event is fired whenever a new moodblock comes into existence.
    event MoodblockCreated(uint256 moodblockId, uint seed);

    /// @dev Moodblock definition
    struct Moodblock {
        // The Moodblock's seed is packed into these 256-bits, which never changes.
        uint seed;

        // The timestamp from the block when this moodblock came into existence.
        uint64 createdAt;
    }

    constructor() ERC721('Moodblocks', 'MBS') {}
    
    /// @dev An array containing the Moodblock struct for all moodblocks in existence. The ID
    ///  of each moodblock is actually an index into this array.
    Moodblock[] public moodblocks;

    /// @dev A private method that creates a new moodblock and stores it.
    function _createRandomMoodblock() private returns (uint256) {
        Moodblock memory _moodblock = Moodblock({
            seed: 1234,
            createdAt: uint64(block.timestamp)
        });

        moodblocks.push(_moodblock);
        uint256 moodblockId = moodblocks.length - 1;

        // Emit the created event
        emit MoodblockCreated(moodblockId, _moodblock.seed);

        return moodblockId;
    }

    /**
     * @notice Mint a Moodblock to the owner.
     */
    function mint() public onlyOwner returns (uint256) {
        uint256 moodblockId = _createRandomMoodblock();
        _safeMint(owner(), moodblockId);
        return moodblockId;
    }
}