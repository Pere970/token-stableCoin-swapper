// migrations/NN_deploy_upgradeable_box.js
const { deployProxy } = require('@openzeppelin/truffle-upgrades');

const TokenUtilities = artifacts.require('TokenUtilities');
const TokenSwapper = artifacts.require('TokenSwapper');
let routerAddress = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D"; //Uniswap Router Address on ETH Mainnet
let factoryAddress = "0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f";//Uniswap Factory Address on ETH Mainnet
let wETHAddress = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"; //WETH Token Address on ETH Mainnet

module.exports = async function (deployer) {
  const tokenUtilities = await deployProxy(TokenUtilities, [routerAddress, factoryAddress, wETHAddress], { deployer });
  const tokenSwapper = await deployProxy(TokenSwapper, [routerAddress], { deployer });
  console.log('Deployed', tokenUtilities.address);
};