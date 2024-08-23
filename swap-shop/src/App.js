// src/App.js
import React from "react";
import SwapShopProvider from "./context/SwapShopContext";
import MintNFT from "./components/MintNFT";
import Profile from "./components/Profile";

function App() {
	return (
		<SwapShopProvider>
			<div className="App">
				<h1>Swap Shop</h1>
				<MintNFT />
				<Profile />
			</div>
		</SwapShopProvider>
	);
}

export default App;
