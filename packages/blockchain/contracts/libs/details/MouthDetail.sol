// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Mouth SVG generator
library MouthDetail {
    uint256 public constant COUNT = 10;
    
    struct Mouth {
        string name;
        string selector;
    }

    /// @notice Returns a `Mouth` by ID
    function getMouth(uint8 id) public pure returns (Mouth memory) {
        require(id > 0 && id <= COUNT, "MouthDetail: Invalid ID supplied");
        return getAll()[id - 1];
    }

    /// @notice Returns all mouths
    function getAll() public pure returns (Mouth[COUNT] memory) {
        return [
            Mouth({ name: "Slightly Sad", selector: "slightlySad" }),
            Mouth({ name: "Wide Open", selector: "wideOpen" }),
            Mouth({ name: "Dissapointed", selector: "dissapointed" }),
            Mouth({ name: "Open Mouth", selector: "openMouth" }),
            Mouth({ name: "Mustache", selector: "mustache" }),
            Mouth({ name: "Mustache Laugh", selector: "mustacheLaugh" }),
            Mouth({ name: "Mustache Tongue", selector: "mustacheTongue" }),
            Mouth({ name: "Smile Tongue", selector: "smileTongue" }),
            Mouth({ name: "White Smile", selector: "whiteSmile" }),
            Mouth({ name: "Neutral", selector: "neutral" })
        ];
    }

    function baseMustache() private pure returns (string memory) {
        return string(
            abi.encodePacked(
                '<path d="M209.976 246.206C205.752 241.453 192.876 232 174.936 232C156.962 232 143.617 240.133 135.447 246.233C133.634 247.587 131.654 249.207 129.528 250.946C122.073 257.046 112.832 264.607 102.766 267.244C91.397 270.223 83.9721 262.731 82.3399 260.872C82.2669 260.789 82.119 260.861 82.1523 260.967C85.6236 271.963 100.269 293 132.723 293C165.632 293 197.885 279.481 209.951 272.694C209.983 272.676 210 272.644 210 272.608V246.271C210 246.247 209.992 246.224 209.976 246.206Z" fill="#111111"/>',
                '<path d="M210.024 246.206C214.248 241.453 227.124 232 245.064 232C263.038 232 276.383 240.133 284.553 246.233C286.366 247.587 288.346 249.207 290.472 250.946C297.927 257.046 307.168 264.607 317.234 267.244C328.603 270.223 336.028 262.731 337.66 260.872C337.733 260.789 337.881 260.861 337.848 260.967C334.376 271.963 319.731 293 287.277 293C254.368 293 222.115 279.481 210.049 272.694C210.017 272.676 210 272.644 210 272.608V246.271C210 246.247 210.008 246.224 210.024 246.206Z" fill="#111111"/>'
            )
        );
    }

    /// @dev Item 1
    function slightlySad() public pure returns (string memory) {
        return group(
            string(
                abi.encodePacked(
                    '<path d="M199.737 264.31C175.693 267.067 161.83 277.106 154.627 284.612C153.086 286.217 150.073 284.855 150.959 282.815C156.549 269.929 170.939 253.329 201.886 249.471C234.132 245.451 258.343 268.164 264.294 282.613C265.01 284.352 263.026 285.43 261.597 284.206C252.774 276.651 230.253 260.81 199.737 264.31Z" fill="#111111"/>'
                )
            )
        );
    }
    
    /// @dev Item 2
    function wideOpen() public pure returns (string memory) {
        return group(
            string(
                abi.encodePacked(
                    '<ellipse cx="210" cy="273" rx="36" ry="39" fill="#111111"/>',
                    '<path d="M238.624 296.656C232.046 305.983 221.671 312 210 312C198.328 312 187.954 305.983 181.376 296.656C187.954 291.394 198.328 288 210 288C221.671 288 232.046 291.394 238.624 296.656Z" fill="#DD6158"/>',
                    '<path d="M239.73 251H180.271C186.755 240.735 197.652 234 210 234C222.349 234 233.245 240.735 239.73 251Z" fill="white"/>'
                )
            )
        );
    }

    /// @dev Item 3
    function dissapointed() public pure returns (string memory) {
        return group(
            '<path d="M196.058 259.743C173.729 269.076 163.203 282.574 158.371 291.787C157.338 293.757 154.065 293.287 154.348 291.08C156.135 277.148 165.342 257.202 193.996 244.891C223.852 232.064 253.424 247.15 263.158 259.375C264.329 260.846 262.723 262.432 261.011 261.654C250.435 256.85 224.397 247.896 196.058 259.743Z" fill="#111111"/>'
        );
    }   

    /// @dev Item 4
    function openMouth() public pure returns (string memory) {
        return group(
            '<path d="M187.763 274.682C182.769 263.465 187.002 250.287 197.593 244.076V244.076C209.448 237.123 224.709 241.472 231.119 253.629L232.492 256.234C238.559 267.741 234.448 281.986 223.182 288.491V288.491C210.735 295.676 194.806 290.501 188.961 277.372L187.763 274.682Z" fill="#111111"/>'
        );
    }

    /// @dev Item 5
    function mustache() public pure returns (string memory) {
        return group(
            baseMustache()
        );
    }

    /// @dev Item 5
    function mustacheLaugh() public pure returns (string memory) {
        return group(
            string(
                abi.encodePacked(
                    '<ellipse cx="210" cy="275" rx="40" ry="27" fill="white"/>',
                    baseMustache()
                )
            )
        );
    }

    /// @dev Item 6
    function mustacheTongue() public pure returns (string memory) {
        return group(
            string(
                abi.encodePacked(
                    '<path d="M240.225 285.604C234.548 274.557 223.038 267 209.762 267C197.012 267 185.89 273.971 180 284.311C188.291 291.796 198.628 297 211.133 297C222.904 297 232.527 292.389 240.225 285.604Z" fill="#DD6158"/>',
                    baseMustache()
                )
            )
        );
    }

    /// @dev Item 7
    function smileTongue() public pure returns (string memory) {
        return group(
            string(
                abi.encodePacked(
                    '<path d="M211.45 254.872C180.439 254.872 160.761 245.185 154.322 241.447C153.515 240.979 152.473 241.736 152.742 242.629C158.759 262.626 177.61 298 211.45 298C245.214 298 262.295 262.785 267.355 242.765C267.587 241.848 266.473 241.119 265.678 241.63C259.68 245.491 241.967 254.872 211.45 254.872Z" fill="#111111"/>',
                    '<path d="M242.141 286.239C236.087 274.667 223.965 266.769 210 266.769C196.582 266.769 184.866 274.059 178.599 284.895C187.359 292.631 198.267 298 211.45 298C223.855 298 234.008 293.246 242.141 286.239Z" fill="#DD6158"/>'
                )
            )
        );
    }

    /// @dev Item 8
    function whiteSmile() public pure returns (string memory) {
        return group(
            string(
                abi.encodePacked(
                    '<path d="M210 254.654C182.8 254.654 165.326 244.865 159.849 241.289C159.122 240.814 158.113 241.38 158.211 242.243C160.379 261.495 173.206 296 210 296C246.794 296 259.621 261.495 261.789 242.243C261.887 241.38 260.878 240.814 260.151 241.289C254.674 244.865 237.2 254.654 210 254.654Z" fill="white"/>'
                )
            )
        );
    }
    
    /// @dev Item 9
    function neutral() public pure returns (string memory) {
        return group(
            string(
                abi.encodePacked(
                    '<rect x="154" y="266" width="112" height="12" rx="2" fill="#111111"/>'
                )
            )
        );
    }

    /// @dev Wraps the children into a group
    function group(string memory children) private pure returns (string memory) {
        return string(
            abi.encodePacked('<g class="mouth">', children, '</g>')
        );
    }
}