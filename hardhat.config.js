require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config()

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.9",
  networks:{
    ropsten:{
      url: process.env.ROPSTEN_RPC_URL ,
      accounts: [`0x${process.env.PRIVATE_KEY}`],
      chainId: 3
    }
  }
};
