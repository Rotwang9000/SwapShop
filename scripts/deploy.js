async function main() {
	// Get the contract factory for SwapShop
	const SwapShop = await hre.ethers.getContractFactory("SwapShop");

	// // Deploy the contract
	const swapShop = await SwapShop.deploy();

	// // Wait for the contract to be deployed
	// // await swapShop.deployed();

	console.log("SwapShop deployed to:", swapShop.address);

	// Get the contract factory for CoolNFT
	const CoolNFT = await hre.ethers.getContractFactory("CoolNFT");

	// Deploy the contract
	const coolNFT = await CoolNFT.deploy();

	// Wait for the contract to be deployed
	// await coolNFT.deployed();

	console.log("CoolNFT deployed to:", coolNFT);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});
