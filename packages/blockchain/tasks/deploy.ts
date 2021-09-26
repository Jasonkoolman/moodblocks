import { Contract, ContractFactory } from '@ethersproject/contracts';
import { task } from 'hardhat/config';
import { Libraries } from 'hardhat/types';
import { networkConfig } from '../network.config';
import prompt from 'prompt';

type ConstructorArgs = unknown[];
type DeployOptions = {
  args?: ConstructorArgs;
  libraries?: Libraries;
};

task('deploy', 'Deploy smart contracts').setAction(async (args, { ethers, run }) => {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface. If this script is run directly using `node`, we want to
  // call compile manually to make sure everything is compiled.
  await run('compile');

  const { chainId } = await ethers.provider.getNetwork();
  const [deployer] = await ethers.getSigners();
  const config = networkConfig[chainId as any];

  // Local hardhat network is considered a development environment.
  // When `isDevelopment` is set to true, mock contracts will be deployed
  // to mock external contracts (i.e. Chainlink VRF).
  const isDevelopment = chainId === 31337;

  if (!config) {
    throw new Error('Chain ID is not supported');
  }

  debug(`Starting deployment on network "${config.name}"`);

  let vrfCoordinatorAddress;
  let linkTokenAddress;
  const keyHash = config['keyHash'];

  if (isDevelopment) {
    const linkTokenMock = await deploy('LinkTokenMock');
    const vrfCoordinatorMock = await deploy('VRFCoordinatorMock', {
      args: [linkTokenMock.address],
    });
    vrfCoordinatorAddress = vrfCoordinatorMock.address;
    linkTokenAddress = linkTokenMock.address;
  } else {
    vrfCoordinatorAddress = config['vrfCoordinator'];
    linkTokenAddress = config['linkToken'];
  }

  // Prompt for gas price
  let gasPrice = await ethers.provider.getGasPrice();
  const gasInGwei = Math.round(Number(ethers.utils.formatUnits(gasPrice, 'gwei')));

  prompt.start();

  let result = await prompt.get([
    {
      properties: {
        gasPrice: {
          type: 'integer',
          required: true,
          description: 'Enter a gas price (gwei)',
          default: gasInGwei,
        },
      },
    },
  ]);

  gasPrice = ethers.utils.parseUnits(result.gasPrice.toString(), 'gwei');

  // Promp for confirmation
  result = await prompt.get([
    {
      properties: {
        confirm: {
          type: 'string',
          description: 'Type "DEPLOY" to confirm:',
        },
      },
    },
  ]);

  if (result.confirm != 'DEPLOY') {
    debug('Aborting...');
    return;
  }

  // Deploy the MoodblockDescriptor contract.
  const moodblockDescriptor = await deploy('MoodblockDescriptor', {
    libraries: await deployLibraries(['BackgroundDetail', 'EyesDetail', 'MouthDetail']),
  });

  // Deploy the MoodblockToken contract.
  const moodblockToken = await deploy('MoodblockToken', {
    args: [moodblockDescriptor.address, vrfCoordinatorAddress, linkTokenAddress, keyHash],
  });

  /**
   * Deploys a contract.
   */
  async function deploy(name: string, options?: DeployOptions): Promise<Contract> {
    debug(`Deploying ${name}...`);
    const factory: ContractFactory = await ethers.getContractFactory(name, {
      libraries: options?.libraries,
    });
    const constructorArgs = options?.args || [];
    const contract = await factory.deploy(...constructorArgs);
    await contract.deployed();
    await verifyDeployment(contract.address, constructorArgs);
    debug(`${name} successfully deployed to: ${contract.address}`);
    return contract;
  }

  /**
   * Deploys libraries by name.
   */
  async function deployLibraries(names: string[]) {
    const libraries: Libraries = {};
    for (const name of names) {
      const contract = await deploy(name);
      libraries[name] = contract.address;
    }
    return libraries;
  }

  /**
   * Verifies a deployment via EtherScan.
   */
  async function verifyDeployment(address: string, args: ConstructorArgs = []) {
    if (isDevelopment) return null;
    return run('verify:verify', {
      address,
      constructorArguments: args,
    });
  }

  function debug(message: any) {
    console.log(message);
  }
});
