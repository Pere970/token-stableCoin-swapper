# token-swapper
Smart Contract used to swap the amount in a token A to token B through the Uniswap/Pancakeswap Router. 

Used Truffle to deploy and test the contact

## Requirements
- Node.js (v12 or later)

For testing make sure to have **ganache-cli** installed as it'll be used to fork the mainnet and interact with "real" Router and Factory contracts.

## Installing

Download the repo and execute **npm install --save** to install all the needed dependencies.
```
git clone https://github.com/Pere970/token-swapper.git
```
```
npm install --save
```
## Commands
Compile smart contracts with truffle:
```
truffle compile
```
Console: to interact with the connected blockchain
```
truffle console
```
To run a console over an specific configured network from the truffle-config:
```
truffle console --network network_from_truffleconfig
```
## Testing
For testing ganache-cli will be used to fork the mainnet and have access to the real Router and Factory contracts.

To do that an [Infura](https://infura.io/) endpoint will be needed.

### Testing Instructions
On a separate terminal run the following command:
```
ganache-cli --fork https://mainnet.infura.io/v3/{YOUR_INFURA_PROJECTID}@{DESIRED_BLOCKNUMBER_TO_FORK_FROM}}
```
This will create a local blockchain forking the mainnet from the blocknumber you specified.

Then on a console on the project folder, while running the locall blockchain, run the following command:
```
truffle test --network mainnet_fork
```
