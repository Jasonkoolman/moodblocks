// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "./IERC677Receiver.sol";

contract VRFCoordinatorMock is IERC677Receiver {
    LinkTokenInterface public LINK;

    event RandomnessRequest(address indexed sender, bytes32 indexed keyHash, uint256 indexed seed);

    constructor(address linkAddress) {
        LINK = LinkTokenInterface(linkAddress);
    }

    function onTokenTransfer(address sender, uint256, bytes memory _data)
        public
        override
        onlyLINK
    {
        (bytes32 keyHash, uint256 seed) = abi.decode(_data, (bytes32, uint256));
        emit RandomnessRequest(sender, keyHash, seed);
    }

    function callBackWithRandomness(
        bytes32 requestId,
        uint256 randomness,
        address consumerContract
    ) public {
        VRFConsumerBase v;
        bytes memory resp = abi.encodeWithSelector(v.rawFulfillRandomness.selector, requestId, randomness);
        require(gasleft() >= 206000, "VRFCoordinatorMock: Not enough gas for consumer");
        (bool success,) = consumerContract.call(resp);
        require(success, "VRFCoordinatorMock: Failed to fulfill randomness at the consumer");
    }

    modifier onlyLINK() {
        require(msg.sender == address(LINK), "VRFCoordinatorMock: Must use LINK token");
        _;
    }
}