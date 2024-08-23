// src/components/Profile.js
import React, { useContext, useEffect, useState } from "react";
import { SwapShopContext } from "../context/SwapShopContext";
import { ethers } from "ethers";
import CoolNFTABI from "../artifacts/contracts/CoolNFT.sol/CoolNFT.json";

const Profile = () => {
	const { account, signer } = useContext(SwapShopContext);
	const [nfts, setNfts] = useState([]);

	useEffect(() => {
		const fetchNFTs = async () => {
			const contract = new ethers.Contract(
				"0x923fe010c5eba7a1bcc7b163e4766831674847b9",
				CoolNFTABI,
				signer
			);
			const balance = await contract.balanceOf(account);
			const nftData = [];
			for (let i = 0; i < balance; i++) {
				const tokenId = await contract.tokenOfOwnerByIndex(account, i);
				const tokenURI = await contract.tokenURI(tokenId);
				nftData.push({ tokenId, tokenURI });
			}
			setNfts(nftData);
		};

		fetchNFTs();
	}, [account, signer]);

	return (
		<div>
			<h2>Your Profile</h2>
			<div>
				{nfts.map((nft) => (
					<div key={nft.tokenId}>
						<h3>NFT #{nft.tokenId}</h3>
						<img src={nft.tokenURI} alt={`NFT #${nft.tokenId}`} />
						<button>Offer for Swap</button>
					</div>
				))}
			</div>
		</div>
	);
};

export default Profile;
