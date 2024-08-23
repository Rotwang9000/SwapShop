import React, { useContext, useState } from "react";
import { SwapShopContext } from "../context/SwapShopContext";

const ProposeSwap = () => {
	const { swapShopContract } = useContext(SwapShopContext);
	const [nftContract, setNftContract] = useState("");
	const [tokenId, setTokenId] = useState("");

	const proposeSwap = async () => {
		try {
			const tx = await swapShopContract.proposeSwap(nftContract, tokenId);
			await tx.wait();
			alert("Swap proposed successfully!");
		} catch (error) {
			console.error(error);
			alert("Failed to propose swap");
		}
	};

	return (
		<div>
			<h2>Propose a Swap</h2>
			<input
				type="text"
				placeholder="NFT Contract Address"
				value={nftContract}
				onChange={(e) => setNftContract(e.target.value)}
			/>
			<input
				type="text"
				placeholder="Token ID"
				value={tokenId}
				onChange={(e) => setTokenId(e.target.value)}
			/>
			<button onClick={proposeSwap}>Propose Swap</button>
		</div>
	);
};

export default ProposeSwap;
