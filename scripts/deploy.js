const { ethers } = require("hardhat")

async function main() {
  const currentTimestampInSeconds = Math.round(Date.now() / 1000)
  const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60
  const unlockTime = currentTimestampInSeconds + ONE_YEAR_IN_SECS

  const AlteriTokenFactory = await ethers.getContractFactory("AlteriToken")

  console.log("Deploying contract...")
  const AlteriToken = await AlteriTokenFactory.deploy()
  await AlteriToken.deployed()

  console.log(`Deployed to address: ${AlteriToken.address}`)
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
