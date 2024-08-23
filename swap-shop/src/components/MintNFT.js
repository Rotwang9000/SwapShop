// src/components/MintNFT.js
import React, { useContext, useState } from "react";
import { ethers } from "ethers";
import { SwapShopContext } from "../context/SwapShopContext";
import CoolNFTABI from "../artifacts/contracts/CoolNFT.sol/CoolNFT.json";

const MintNFT = () => {
	const { signer } = useContext(SwapShopContext);
	const [mintedTokenId, setMintedTokenId] = useState(null);

	const mintNFT = async () => {
		try {
			const contract = new ethers.Contract(
				"0x923fe010c5eba7a1bcc7b163e4766831674847b9",
				CoolNFTABI,
				signer
			);

			const tx = await contract.mintNFT();
			const receipt = await tx.wait();
			const tokenId = receipt.events[0].args.tokenId.toNumber();
			setMintedTokenId(tokenId);
			alert(`Minted NFT with Token ID: ${tokenId}`);
		} catch (error) {
			console.error(error);
			alert("Minting failed");
		}
	};

	return (
		<div>
			<h2>Mint Your Cool NFT</h2>
			<button onClick={mintNFT}>Mint NFT</button>
			{mintedTokenId && <p>Your new NFT ID: {mintedTokenId}</p>}
		</div>
	);
};

export default MintNFT;
