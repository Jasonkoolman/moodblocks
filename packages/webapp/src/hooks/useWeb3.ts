import { useWeb3React } from "@web3-react/core";
import { Web3Provider } from "@ethersproject/providers";

/**
 * Hook to enable authentication using Web3.
 */
export function useWeb3() {
  const context = useWeb3React<Web3Provider>();
  return context;
}
