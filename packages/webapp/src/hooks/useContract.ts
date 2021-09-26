import { Contract, Signer, ContractTransaction, BigNumberish, BytesLike } from 'ethers';
import { useCallback, useMemo } from 'react';
import { getMoodblockTokenContract } from '../utils/contracts';
import { useWeb3 } from './useWeb3';

export type TransactionRequest = {
  to?: string;
  from?: string;
  nonce?: BigNumberish;

  gasLimit?: BigNumberish;
  gasPrice?: BigNumberish;

  data?: BytesLike;
  value?: BigNumberish;
  chainId?: number;
};

type UseContractOptions = {
  address: string;
  getter: (address: string, signer: Signer) => Contract;
};

type UseContractResult = {
  contract: Contract | null;
  call: <T = any>(name: string, ...args: any[]) => Promise<T>;
  send: (name: string, args: TransactionRequest) => Promise<ContractTransaction>;
};

export const useContract = ({ address, getter }: UseContractOptions): UseContractResult => {
  const { library } = useWeb3();

  const contract = useMemo(
    () => (library ? getter(address, library.getSigner()) : null),
    [address, library, getter],
  );

  const call = useCallback(
    (name: string, ...args: any[]) =>
      contract && contract.hasOwnProperty(name) ? contract[name](args) : Promise.reject(),
    [contract],
  );

  const send = useCallback(
    (name: string, args: TransactionRequest) =>
      contract && contract.hasOwnProperty(name) ? contract[name](args) : Promise.reject(),
    [contract],
  );

  return { contract, call, send };
};

export const useMoodblockToken = (address: string): UseContractResult => {
  return useContract({
    address,
    getter: getMoodblockTokenContract,
  });
};
