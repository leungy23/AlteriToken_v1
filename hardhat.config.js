require("@nomicfoundation/hardhat-toolbox")
require("@nomiclabs/hardhat-waffle")
require("dotenv").config()

const MUMBAI_RPC_URL = process.env.MUMBAI_RPC_URL
const PRIVATE_KEY = process.env.PRIVATE_KEY
const CMC_API_KEY = process.env.CMC_API_KEY

module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    mumbai: {
      url: MUMBAI_RPC_URL,
      accounts: [PRIVATE_KEY],
      chainId: 80001,
    },
  },
  solidity: "0.8.7",
  gasReporter: {
    enabled: false,
    outputFile: "gas-report.txt",
    noColors: true,
    currency: "USD",
    coinmarketcap: CMC_API_KEY,
    //token: "MATIC",
  },
}
