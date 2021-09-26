import { Contract, Signer, providers, ContractInterface } from 'ethers';

// TODO: Use relative import as soon as @moodblocks/blockchain is available as a package.
import { default as MoodblockTokenABI } from '../abis/MoodblockToken.json';

type SignerOrProvider = Signer | providers.Provider;

export const getContract = (abi: ContractInterface, address: string, signer?: SignerOrProvider) => {
  // const signerOrProvider = signer ?? simpleRpcProvider;
  return new Contract(address, abi, signer);
};

export const getMoodblockTokenContract = (address: string, signer?: SignerOrProvider) =>
  getContract(MoodblockTokenABI, address, signer);
