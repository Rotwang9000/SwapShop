require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
	solidity: "0.8.24",
	networks: {
		kiichain: {
			url: "https://a.sentry.testnet.kiivalidator.com:8645/",
			chainId: 123454321,
			accounts: [`${process.env.PRIVATE_KEY}`],
		},
	},
};
