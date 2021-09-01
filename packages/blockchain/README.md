# @moodblocks/blockchain

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts.

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
await token.transfer('0xdd2fd4581271e230360230f9337d5c0430bf44c0', 42069);
```

- Use `await` to avoid Promise objects.
- `.toString()` helps you to display uint256 numbers (which are too big for JS).
