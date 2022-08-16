/// TX DE PRUEBA = 0xa4032b5fbeb36b538ead7a31dc6acd17a1d91da21540fc424b137f9f73c05000
/// RED ROPSTEN

const hre = require("hardhat");
const { ethers  } = require("hardhat");
const sushiToken = "0x81DB9C598b3ebbdC92426422fc0A1d06E77195ec"
const daiToken = "0xaD6D458402F60fD3Bd25163575031ACDce07538D"
const abiSushi = require("../ABIS/abiSushi.json")
const abiUsdc = require("../ABIS/abiUsdc.json")


var  SushiSwap
var deploySushiChalleng;
var daiTokenContract;
var SushiTokenContract;

const signer = new ethers.Wallet(
  process.env.PRIVATE_KEY,
  new ethers.providers.InfuraProvider("ropsten",process.env.KEY )
);


async function main() {

  const [deployer] = await hre.ethers.getSigners();
  console.log(`Deploying contracts with the account: ${deployer.address}`);

  SushiSwap = await hre.ethers.getContractFactory("SushiSwapChallenge")
  deploySushiChalleng = await SushiSwap.deploy()


  console.log("deploySushiChalleng to:", deploySushiChalleng.address);


  SushiTokenContract= new ethers.Contract(     
    sushiToken,
    abiSushi,
    signer
  )

  daiTokenContract = new ethers.Contract(             
    daiToken,
    abiUsdc,
    signer
  )
  
  const balance = await SushiTokenContract.balanceOf(deployer.address )
  const balanceDai = await daiTokenContract.balanceOf(deployer.address )



  
 await SushiTokenContract.connect(deployer).approve(deploySushiChalleng.address, balance )

   
 await daiTokenContract.connect(deployer).approve(deploySushiChalleng.address, balanceDai)
 
 const challengeSushi = await deploySushiChalleng.sushiLiquiditySLP(balance, balanceDai, 0)
 console.log(challengeSushi)
  
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
