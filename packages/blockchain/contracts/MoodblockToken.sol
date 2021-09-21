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
    uint256 private constant _basePrice = 0.01 ether;

    /// @dev Increase of the price every step.
    uint256 private constant _increasedPrice = 0.005 ether;

    /// @dev All moodblocks in existence.
    mapping(uint256 => Moodblock) private _moodblocks;

    /// @dev The address of the token descriptor contract.
    address public immutable descriptor;

    /// @dev Chainlink keyhash
    bytes32 internal keyHash;

    /// @dev Chainlink RNG fee
    uint256 internal fee;

    /// @dev Number received from Chainlink RNG.
    uint256 internal randomResult = 0;

    /// @dev The rate at which to request a random number.
    uint8 internal rngRequestRate = 10;

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

        // Update randomResult every 'rngRequestRate' call.
        if (totalSupply() % rngRequestRate == 0) {
            _requestRandomNumber();
        }

        uint256 moodblockId = totalSupply() + 1;
        uint256 seed = block.timestamp + randomResult;

        Moodblock memory _moodblock = Moodblock({
            skin: 1,
            face: 1,
            eye: IMoodblockDescriptor(descriptor).generateEyeId(moodblockId, seed),
            eyeColor: 1,
            eyebrow: IMoodblockDescriptor(descriptor).generateEyebrowId(moodblockId, seed),
            mouth: IMoodblockDescriptor(descriptor).generateMouthId(moodblockId, seed),
            mark: IMoodblockDescriptor(descriptor).generateMarkId(moodblockId, seed),
            background: 1,
            createdAt: uint64(block.timestamp)
        });

        _moodblocks[moodblockId] = _moodblock;

        emit MoodblockCreated(moodblockId);

        _safeMint(msg.sender, moodblockId);
    }

    /// @notice Get the current price of one Moodblock.
    /// The price is progressive. Every x sales, the price increases by `increasedPrice` ether.
    function getUnitPrice() public view returns (uint256) {
        return _basePrice + (totalSupply() * _increasedPrice);
    }

    /// @notice Get the details of a Moodblock.
    function details(uint256 tokenId) external view override returns (Moodblock memory) {
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
    function setRngRequestRate(uint8 rate) public onlyOwner {
        require(rate > 0, "MoodblockToken: Rate must be larger than 0");
        rngRequestRate = rate;
    }

    /// @notice Send funds from sales to the owner.
    function withdrawAll() public onlyOwner {
        uint256 amount = address(this).balance;
        (bool success, ) = payable(owner()).call{value: amount}("");
        require(success, "MoodblockToken: Failed to withdraw");
    }

    /// @notice Withdraw LINK from the contract to the owner.
    function withdrawLink() public onlyOwner {
        require(LINK.transfer(owner(), LINK.balanceOf(address(this))), "MoodblockToken: Unable to withdraw LINK");
    }

    /// @dev Request a random number.
    function _requestRandomNumber() private returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "MoodblockToken: Insufficient LINK to request randomness");
        return requestRandomness(keyHash, fee);
    }
}