// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "base64-sol/base64.sol";

contract CoolNFT is ERC721URIStorage, Ownable {
    uint256 public tokenCounter;

    constructor() ERC721("CoolNFT", "CNFT") Ownable(msg.sender) {
        tokenCounter = 0;
    }

    function mintNFT() public returns (uint256) {
        uint256 newTokenId = tokenCounter;

        string memory svg = generateSVG(newTokenId);
        string memory imageURI = svgToImageURI(svg);
        string memory tokenURI = formatTokenURI(imageURI);

        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, tokenURI);

        tokenCounter += 1;
        return newTokenId;
    }

    function generateSVG(uint256 tokenId) internal view returns (string memory) {
        // Generate pseudo-random colors and positions based on the tokenId, sender address, and block info
        uint256 randomness = uint256(keccak256(abi.encodePacked(tokenId, msg.sender, block.timestamp, block.prevrandao)));
        
        string memory color1 = string(abi.encodePacked("rgb(", toString(randomness % 256), ",", toString((randomness / 256) % 256), ",", toString((randomness / 256 / 256) % 256), ")"));
        string memory color2 = string(abi.encodePacked("rgb(", toString((randomness / 256 / 256 / 256) % 256), ",", toString((randomness / 256 / 256 / 256 / 256) % 256), ",", toString((randomness / 256 / 256 / 256 / 256 / 256) % 256), ")"));

        string memory svg = string(
            abi.encodePacked(
                "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 400 400' width='400' height='400'>",
                "<rect width='400' height='400' fill='", color1, "'/>",
                "<circle cx='", toString((randomness % 200) + 100), "' cy='", toString((randomness % 200) + 100), "' r='", toString((randomness % 50) + 50), "' fill='", color2, "' opacity='0.6'/>",
                "<rect x='50' y='50' width='300' height='300' fill='none' stroke='white' stroke-width='20' opacity='0.2'/>",
                "</svg>"
            )
        );

        return svg;
    }

    function svgToImageURI(string memory svg) internal pure returns (string memory) {
        string memory base64EncodedSVG = Base64.encode(bytes(svg));
        return string(abi.encodePacked("data:image/svg+xml;base64,", base64EncodedSVG));
    }

    function formatTokenURI(string memory imageURI) internal pure returns (string memory) {
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"CoolNFT", "description":"An automatically generated cool NFT.", "image":"', imageURI, '"}'
                        )
                    )
                )
            )
        );
    }

    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}
