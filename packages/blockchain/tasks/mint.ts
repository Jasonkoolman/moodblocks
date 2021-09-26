import { task, types } from 'hardhat/config';
import { Contract, ContractTransaction, utils } from 'ethers';

task('mint', 'Mints a Moodblock')
  .addParam('from', 'The from address', '', types.string)
  .addParam('price', 'The unit price in ETH', '0.01', types.string)
  .addParam(
    'contract',
    'The `MoodblockToken` contract address',
    '0x0165878A594ca255338adfa4d48449f69242Eb8F',
    types.string,
  )
  .setAction(async (args, { ethers }) => {
    const MoodblockToken = await ethers.getContractFactory('MoodblockToken');

    const [deployer] = await ethers.getSigners();
    const contract = new Contract(args.contract, MoodblockToken.interface, args.signer || deployer);

    const transaction: ContractTransaction = await contract.mint({
      value: utils.parseEther(args.price),
      gasLimit: 350000,
    });
    const receipt = await transaction.wait(1);

    const moodblockCreatedEvent = receipt.events?.find(e => e.event === 'MoodblockCreated');
    const moodblockId = moodblockCreatedEvent?.args?.moodblockId;
    const moodblockDetails = await contract.getMoodblock(moodblockId);
    console.log('Minted Moodblock with details: ', moodblockDetails);
    const tokenURI = await contract.tokenURI(moodblockId);
    console.log(tokenURI);
  });
