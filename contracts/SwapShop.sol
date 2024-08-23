// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SwapShop is Ownable {
    struct Swap {
        address proposer;
        address proposedNFTContract;
        uint256 proposedTokenId;
        address accepter;
        address accepterNFTContract;
        uint256 accepterTokenId;
        bool proposerConfirmed;
        bool accepterConfirmed;
    }

    mapping(uint256 => Swap) public swaps;
    uint256 public swapCounter;

    event SwapProposed(uint256 indexed swapId, address proposer, address proposedNFTContract, uint256 proposedTokenId);
    event SwapAccepted(uint256 indexed swapId, address accepter, address accepterNFTContract, uint256 accepterTokenId);
    event SwapCancelled(uint256 indexed swapId);
    event SwapFinalised(uint256 indexed swapId);

    constructor() Ownable(msg.sender) {
        swapCounter = 0;
    }





    function proposeSwap(address nftContract, uint256 tokenId) external {
        IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);
        
        swapCounter++;
        swaps[swapCounter] = Swap({
            proposer: msg.sender,
            proposedNFTContract: nftContract,
            proposedTokenId: tokenId,
            accepter: address(0),
            accepterNFTContract: address(0),
            accepterTokenId: 0,
            proposerConfirmed: false,
            accepterConfirmed: false
        });

        emit SwapProposed(swapCounter, msg.sender, nftContract, tokenId);
    }

    function acceptSwap(uint256 swapId, address nftContract, uint256 tokenId) external {
        Swap storage swap = swaps[swapId];
        require(swap.accepter == address(0), "Swap already accepted");

        IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);
        
        swap.accepter = msg.sender;
        swap.accepterNFTContract = nftContract;
        swap.accepterTokenId = tokenId;

        emit SwapAccepted(swapId, msg.sender, nftContract, tokenId);
    }

    function confirmSwap(uint256 swapId) external {
        Swap storage swap = swaps[swapId];
        require(swap.proposer == msg.sender || swap.accepter == msg.sender, "Not a participant in this swap");

        if (swap.proposer == msg.sender) {
            swap.proposerConfirmed = true;
        } else {
            swap.accepterConfirmed = true;
        }

        if (swap.proposerConfirmed && swap.accepterConfirmed) {
            _finaliseSwap(swapId);
        }
    }

    function cancelSwap(uint256 swapId) external {
        Swap storage swap = swaps[swapId];
        require(swap.proposer == msg.sender || swap.accepter == msg.sender, "Not a participant in this swap");
        require(!swap.proposerConfirmed || !swap.accepterConfirmed, "Swap already confirmed by both parties");

        if (swap.proposer == msg.sender) {
            IERC721(swap.proposedNFTContract).transferFrom(address(this), swap.proposer, swap.proposedTokenId);
        } else if (swap.accepter == msg.sender) {
            IERC721(swap.accepterNFTContract).transferFrom(address(this), swap.accepter, swap.accepterTokenId);
        }

        delete swaps[swapId];
        emit SwapCancelled(swapId);
    }

    function _finaliseSwap(uint256 swapId) internal {
        Swap storage swap = swaps[swapId];

        IERC721(swap.proposedNFTContract).transferFrom(address(this), swap.accepter, swap.proposedTokenId);
        IERC721(swap.accepterNFTContract).transferFrom(address(this), swap.proposer, swap.accepterTokenId);

        emit SwapFinalised(swapId);

        delete swaps[swapId];
    }
}
