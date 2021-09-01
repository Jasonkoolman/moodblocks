import { HardhatUserConfig } from 'hardhat/config';
import '@nomiclabs/hardhat-ethers';
import '@nomiclabs/hardhat-waffle';
// import '@typechain/hardhat';
import 'hardhat-abi-exporter';
import './tasks';

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more
const config: HardhatUserConfig = {
  solidity: '0.8.4',
  networks: {
    hardhat: {
      chainId: 31337,
    },
  },
  abiExporter: {
    path: './abi',
    clear: true,
  },
};

export default config;
