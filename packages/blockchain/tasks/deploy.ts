import { task } from 'hardhat/config';

task('deploy', 'Deploy smart contracts').setAction(async (args, { ethers, run }) => {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface. If this script is run directly using `node`, we want to
  // call compile manually to make sure everything is compiled.
  await run('compile');

  // Deploy Greeter
  const Greeter = await ethers.getContractFactory('Greeter');
  const greeter = await Greeter.deploy('Hello world!');
  await greeter.deployed();

  // Deploy MoodblockToken
  const MoodblockToken = await ethers.getContractFactory('MoodblockToken');
  const moodblockToken = await MoodblockToken.deploy();
  await moodblockToken.deployed();

  console.log('MoodblockToken deployed to:', moodblockToken.address);
});
