import { HardhatUserConfig } from 'hardhat/config';
import '@nomiclabs/hardhat-ethers';
import '@nomiclabs/hardhat-etherscan';
import '@nomiclabs/hardhat-waffle';
// import '@typechain/hardhat';
import 'hardhat-gas-reporter';
import 'hardhat-abi-exporter';
import './tasks';

require('dotenv').config();
requireEnv(['MNEMONIC', 'ETHERSCAN_API_KEY']);

const { MNEMONIC, ETHERSCAN_API_KEY, RINKEBY_RPC_URL, REPORT_GAS } = process.env;

function requireEnv(keys: string[]) {
  keys.forEach(key => {
    if (!process.env[key]) {
      throw new Error(`Environment variable "${key}" not set`);
    }
  });
}

const config: HardhatUserConfig = {
  solidity: '0.8.4',
  networks: {
    hardhat: {
      chainId: 31337,
    },
    rinkeby: {
      url: RINKEBY_RPC_URL,
      accounts: {
        mnemonic: MNEMONIC,
      },
    },
  },
  gasReporter: {
    enabled: REPORT_GAS ? true : false,
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
  },
  abiExporter: {
    path: './abi',
    clear: true,
  },
};

export default config;
