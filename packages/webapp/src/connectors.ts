import { InjectedConnector } from '@web3-react/injected-connector';

const CHAIN_IDS = [
  // 1, // Mainet
  3, // Ropsten
  4, // Rinkeby
  5, // Goerli
  42, // Kovan,
  31337, // Hardhat
];

export const injected = new InjectedConnector({ supportedChainIds: CHAIN_IDS });
