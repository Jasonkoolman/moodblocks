import { Contract } from 'ethers';
import { useMemo } from 'react';
import { getMoodblockFactoryContract } from '../utils/contracts';
import { useWeb3 } from './useWeb3';

export const useMoodblockFactory = (address: string): Contract | null => {
  const { library } = useWeb3();
  return useMemo(
    () => (library ? getMoodblockFactoryContract(address, library.getSigner()) : null),
    [address, library],
  );
};
