// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeCast.sol";

/// @title Helper for details generation
library DetailHelper {
    /// @notice Generate a random number and return the index from the
    ///         corresponding interval.
    /// @param max The maximum value to generate
    /// @param seed Used for the initialization of the number generator
    /// @param intervals the intervals
    /// @param selector Caller selector
    /// @param tokenId the current tokenId
    function generate(
        uint256 max,
        uint256 seed,
        uint256[] memory intervals,
        bytes4 selector,
        uint256 tokenId
    ) internal view returns (uint8) {
        uint256 randomNumber = generateRandom(max, seed, tokenId, selector);
        return pickItem(randomNumber, intervals);
    }

    /// @notice Generate random number between 1 and max
    /// @param max Maximum value of the random number
    /// @param seed Used for the initialization of the number generator
    /// @param tokenId Current tokenId used as seed
    /// @param selector Caller selector used as seed
    function generateRandom(
        uint256 max,
        uint256 seed,
        uint256 tokenId,
        bytes4 selector
    ) internal view returns (uint256) {
        return
            (uint256(
                keccak256(
                    abi.encodePacked(block.difficulty, block.number, tx.origin, tx.gasprice, selector, seed, tokenId)
                )
            ) % max) + 1;
    }

    /// @notice Pick an item for the given random value
    /// @param val The random value
    /// @param intervals The intervals for the corresponding items
    /// @return the item ID where : intervals[] index = item ID
    function pickItem(uint256 val, uint256[] memory intervals) internal pure returns (uint8) {
        for (uint256 i; i < intervals.length; i++) {
            if (val > intervals[i]) {
                return SafeCast.toUint8(i);
            }
        }
        revert("DetailHelper: No item picked");
    }
}