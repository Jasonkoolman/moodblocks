# @moodblocks/blockchain

Contracts for Moodblock NFTs, stored and rendered on-chain.

TODO: Use solcov: https://hardhat.org/plugins/solidity-coverage.html

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
npx hardhat help
```

## Development

You can deploy in the localhost network following these steps:

Start a local node

`yarn dev`

Open a new terminal and deploy the smart contract in the localhost network

`yarn dev:deploy`

Mint your first moodblock:

`yarn dev:mint`

Check balance of the first address:

`npx hardhat balance --network localhost --account 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266`

### Interacting with contract

Open the console:

`yarn dev:console`

Get the ethers.js contract factory and attach to it.

```js
const Token = await ethers.getContractFactory('MoodblockToken');
const token = await Token.attach('0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266');
```

Interact with the contract:

```js
await token.transfer('0xdd2fd4581271e230360230f9337d5c0430bf44c0', 10000);
```

- Use `await` to avoid Promise objects.
- `.toString()` helps you to display uint256 numbers (which are too big for JS).
