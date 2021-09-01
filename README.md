# Moodblocks monorepo

The official monorepo for Moodblocks using [Yarn Workspaces](https://classic.yarnpkg.com/en/docs/workspaces/) and [Lerna](https://github.com/lerna/lerna).

## Installation

Make sure you have `npm` and `yarn` installed:

```bash
npm install -g npm
npm install --g yarn
```

Install the dependencies:

```
yarn
```

Build the packages:

```
yarn build
```

Run all tests:

```
yarn test
```

## Packages

Each package contains its own README.

- @moodblocks/blockchain: Smart Contracts using Hardhat
- @moodblocks/webapp: Client-side React application
