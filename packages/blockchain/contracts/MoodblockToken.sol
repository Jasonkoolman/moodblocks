// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "./interfaces/IMoodblock.sol";
import "./interfaces/IMoodblockDescriptor.sol";

contract MoodblockToken is ERC721Enumerable, Ownable, IMoodblock, ReentrancyGuard, VRFConsumerBase {
    string private constant NAME = 'Moodblocks';
    string private constant SYMBOL = 'MBS';

    /// @dev The Created event is fired whenever a new moodblock comes into existence.
    event MoodblockCreated(uint256 moodblockId);

    /// @dev Price for one Moodblock (at the beggining).
    uint256 private constant _basePrice = 0.005 ether;

    /// @dev Increase of the price every step.
    uint256 private constant _increasePrice = 0.005 ether;

    /// @dev Number of sales to increase the price.
    uint256 private constant _step = 1000;

    /// @dev All Moodblocks in existence.
    mapping(uint256 => Moodblock) private _moodblocks;

    /// @dev All Moodblocks generated based on ids hash.
    mapping(bytes32 => uint16) private _hashes;

    /// @dev The address of the token descriptor contract.
    address public immutable descriptor;

    /// @dev Chainlink keyhash
    bytes32 internal keyHash;

    /// @dev Chainlink RNG fee
    uint256 internal fee;

    /// @dev Number received from Chainlink RNG.
    uint256 internal randomResult = 0;

    /// @dev The rate at which to request a random number.
    uint8 internal randomRequestRate = 10;

    constructor(
        address _descriptor, 
        address _vrfCoordinator,
        address _linkToken,
        bytes32 _keyHash
    )
        ERC721(NAME, SYMBOL)
        VRFConsumerBase(
            _vrfCoordinator, // VRF Coordinator
            _linkToken       // LINK Token
        )
    {
        descriptor = _descriptor;
        keyHash = _keyHash;
        fee = 1 * 10**18; // TODO: Don't hardcore this.
    }

    /// @notice Mint a random Moodblock to the sender.
    function mint() public payable nonReentrant {
        require(msg.value >= getUnitPrice(), "MoodblockToken: Ether sent is not correct");

        // Update randomResult every 'randomRequestRate' call.
        if (totalSupply() % randomRequestRate == 0) {
            _safeRequestRandomness();
        }

        uint256 moodblockId = totalSupply() + 1;
        uint256 seed = block.timestamp + randomResult;

        Moodblock memory _moodblock = Moodblock({
            eyes: IMoodblockDescriptor(descriptor).generateEyesId(moodblockId, seed),
            mouth: IMoodblockDescriptor(descriptor).generateMouthId(moodblockId, seed),
            mark: IMoodblockDescriptor(descriptor).generateMarkId(moodblockId, seed),
            background: IMoodblockDescriptor(descriptor).generateBackgroundId(moodblockId, seed),
            generation: 1,
            created: uint64(block.timestamp),
            creator: msg.sender
        });

        _moodblock.generation = copyMoodblock(_moodblock);
        _moodblocks[moodblockId] = _moodblock;

        emit MoodblockCreated(moodblockId);

        _safeMint(msg.sender, moodblockId);
    }

    /// @notice Get the current price of one Moodblock.
    /// The price is progressive. Every x sales, the price increases by `increasePrice` ether.
    function getUnitPrice() public view returns (uint256) {
        return ((totalSupply() / _step) * _increasePrice) + _basePrice;
    }

    /// @notice Get the details of a Moodblock.
    function getMoodblock(uint256 tokenId) external view override returns (Moodblock memory) {
        return _moodblocks[tokenId];
    }

    /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
    /// @dev See {IERC721Metadata-tokenURI}.
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), 'MoodblockToken: URI query for nonexistent token');
        return IMoodblockDescriptor(descriptor).tokenURI(_moodblocks[tokenId], tokenId);
    }

    /// @dev Callback function used by VRF Coordinator.
    function fulfillRandomness(bytes32, uint256 randomness) internal override {
        randomResult = randomness;
    }

    /// @notice Set the RNG request rate.
    function setRandomRequestRate(uint8 rate) public onlyOwner {
        require(rate > 0, "MoodblockToken: Rate must be larger than 0");
        randomRequestRate = rate;
    }

    /// @notice Send funds from sales to the owner.
    function withdrawAll() public onlyOwner {
        uint256 amount = address(this).balance;
        (bool success, ) = payable(owner()).call{value: amount}("");
        require(success, "MoodblockToken: Failed to withdraw funds");
    }

    /// @notice Withdraw LINK from the contract to the owner.
    function withdrawLink() public onlyOwner {
        require(LINK.transfer(owner(), LINK.balanceOf(address(this))), "MoodblockToken: Unable to withdraw LINK");
    }

    /// @dev Request a random number.
    function _safeRequestRandomness() private {
        if (LINK.balanceOf(address(this)) >= fee) {
            requestRandomness(keyHash, fee);
        }        
    }

    /// @dev Check is an Moodblock already exists (based on details).
    /// @return False if it already exists, true if not.
    function copyMoodblock(Moodblock memory moodblock) private returns (uint16) {
        bytes32 hash = keccak256(
            abi.encode(
                moodblock.eyes,
                moodblock.mouth,
                moodblock.mark,
                moodblock.background
            )
        );
        uint16 generation = _hashes[hash] = _hashes[hash] + 1;
        return generation;
    }
}