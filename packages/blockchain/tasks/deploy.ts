import { Contract, ContractFactory } from '@ethersproject/contracts';
import { task } from 'hardhat/config';
import { networkConfig } from '../network.config';

type ConstructorArguments = unknown[];

task('deploy', 'Deploy smart contracts').setAction(async (args, { ethers, run }) => {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface. If this script is run directly using `node`, we want to
  // call compile manually to make sure everything is compiled.
  await run('compile');

  const { chainId } = await ethers.provider.getNetwork();
  const [deployer] = await ethers.getSigners();
  const config = networkConfig[chainId as any];

  if (!config) {
    throw new Error('Chain ID is not supported');
  }

  let vrfCoordinatorAddress, linkTokenAddress;
  const keyHash = config['keyHash'];

  if (await isDevelopment()) {
    console.log('Development environment detected...');
    const linkTokenMock = await deploy('LinkTokenMock');
    const vrfCoordinatorMock = await deploy('VRFCoordinatorMock', [linkTokenMock.address]);
    vrfCoordinatorAddress = vrfCoordinatorMock.address;
    linkTokenAddress = linkTokenMock.address;
  } else {
    vrfCoordinatorAddress = config['vrfCoordinator'];
    linkTokenAddress = config['linkToken'];
  }

  // Deploy MoodblockDescriptor
  const moodblockDescriptor = await deploy('MoodblockDescriptor');

  // Deploy MoodblockToken
  const moodblockToken = await deploy('MoodblockToken', [
    moodblockDescriptor.address,
    vrfCoordinatorAddress,
    linkTokenAddress,
    keyHash,
  ]);

  /**
   * Deploys a contract.
   */
  async function deploy(name: string, args: ConstructorArguments = []): Promise<Contract> {
    console.log(`Deploying ${name}...`);
    const factory = await ethers.getContractFactory(name);
    const contract = await factory.deploy(...args);
    await contract.deployed();
    await verifyDeployment(contract.address, args);
    console.log(`${name} successfully deployed to: ${contract.address}`);
    return contract;
  }

  /**
   * Verifies a deployment via EtherScan.
   */
  async function verifyDeployment(address: string, args: ConstructorArguments = []) {
    if (await isDevelopment()) return null;
    return run('verify:verify', {
      address,
      constructorArguments: args,
    });
  }

  async function isDevelopment() {
    const { chainId } = await ethers.provider.getNetwork();
    return chainId === 31337;
  }
});
