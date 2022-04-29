const BEP20Dao = artifacts.require("BEP20DAOToken");
const TokenSwapper = artifacts.require("TokenSwapper");
const TokenUtilities = artifacts.require("TokenUtilities");

contract(
    "Token Swapper", accounts => {
        let token;
        let tokenSwapper;
        let tokenUtilities;
        let transferAmount = 100;
        let tokenSupply = 1000;
        let routerAddress = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D"; //Uniswap Router Address on ETH Mainnet
        let factoryAddress = "0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f";//Uniswap Factory Address on ETH Mainnet
        let wETHAddress = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"; //WETH Token Address on ETH Mainnet

        beforeEach(async () => {
            token = await BEP20Dao.new("Test Token", "TEST", tokenSupply);
            tokenSwapper = await TokenSwapper.new(routerAddress);
            tokenUtilities = await TokenUtilities.new(routerAddress, factoryAddress, wETHAddress);
            //We give the tokenUtilities smart contract some tokens to work with
            await token.transfer(tokenUtilities.address, String( (tokenSupply/2) * 10 ** 18) );
            await tokenUtilities.addLiquidityETH(token.address, String( (tokenSupply/2) * 10 ** 18), { value: web3.utils.toWei("1", "ether") } );
            await token.transfer(tokenSwapper.address, String( transferAmount * 10 ** 18) );
        });

        it("Swaps TEST tokens to WETH", async() => {
            var initialWETHBalance = await tokenSwapper.getBalance(wETHAddress);
            var initialTESTBalance = await tokenSwapper.getBalance(token.address);
            await tokenSwapper.swapTokens(token.address, wETHAddress);
            var currentTESTBalance = await tokenSwapper.getBalance(token.address);
            var currentWETHBalance = await tokenSwapper.getBalance(wETHAddress);
            assert.equal(initialTESTBalance, transferAmount * 10 ** 18);
            assert.equal(initialWETHBalance, 0);
            assert.equal(currentTESTBalance, 0);
            assert(currentWETHBalance > initialWETHBalance);
        });

        it("Swaps TEST tokens to WETH and WETH can be withdrawn", async() => {
            await tokenSwapper.swapTokens(token.address, wETHAddress);
            var initialWETHBalance = await tokenSwapper.getBalance(wETHAddress);
            await tokenSwapper.withdrawTokens(wETHAddress);
            var currentWETHBalance = await tokenSwapper.getBalance(wETHAddress);
            assert(initialWETHBalance > 0);
            assert.equal(currentWETHBalance, 0);
        });
    }
);