import useSWR from 'swr';
import { useWeb3 } from '../hooks';

const web3Fetcher =
  (library: any) =>
  (...args: any) => {
    const [method, ...params] = args;
    return library[method](...params);
  };

export const Balance = () => {
  const { account, library } = useWeb3();
  const { data: balance } = useSWR(['getBalance', account, 'latest'], {
    fetcher: web3Fetcher(library),
  });
  if (!balance) {
    return <div>...</div>;
  }
  return <div>Balance: {balance.toString()}</div>;
};
