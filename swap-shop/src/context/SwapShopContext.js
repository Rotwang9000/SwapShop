import React, { useEffect, useState, createContext } from "react";
import { ethers } from "ethers";
import { Kii } from "kiijs-sdk";
import SwapShopABI from "../artifacts/contracts/SwapShop.sol/SwapShop.json";
import { JsonRpcProvider } from "ethers";


export const SwapShopContext = createContext();

const SwapShopProvider = ({ children }) => {
	const [provider, setProvider] = useState(null);
	const [signer, setSigner] = useState(null);
	const [swapShopContract, setSwapShopContract] = useState(null);
	const [account, setAccount] = useState(null);

	useEffect(() => {
		const initWeb3 = async () => {
			if (window.ethereum) {
				const provider = new JsonRpcProvider("https://rpc.kiichain.com");

				const signer = provider.getSigner();
				const account = await signer.getAddress();
				const network = await provider.getNetwork();

				const contract = new ethers.Contract(
					"0x1983a66c298b94faf991eb87a09dcc0f913e971b", // Replace with your deployed contract address
					SwapShopABI.abi,
					signer
				);

				setProvider(provider);
				setSigner(signer);
				setAccount(account);
				setSwapShopContract(contract);
			}
		};

		initWeb3();
	}, []);

	return (
		<SwapShopContext.Provider
			value={{ provider, signer, swapShopContract, account }}>
			{children}
		</SwapShopContext.Provider>
	);
};

export default SwapShopProvider;
