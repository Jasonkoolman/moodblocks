type ChainID = number;
type Config = {
  name: string;
  linkToken: string | null;
  vrfCoordinator: string | null;
  keyHash: string;
};

export const networkConfig: Record<ChainID, Config> = {
  31337: {
    name: 'localhost',
    linkToken: '0x01BE23585060835E02B77ef475b0Cc51aA1e0709',
    vrfCoordinator: '0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B',
    keyHash: '0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311',
  },
  4: {
    name: 'rinkeby',
    linkToken: '0x01BE23585060835E02B77ef475b0Cc51aA1e0709',
    vrfCoordinator: '0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B',
    keyHash: '0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311',
  },
  1: {
    name: 'mainnet',
    linkToken: '0x514910771AF9Ca656af840dff83E8264EcF986CA',
    vrfCoordinator: '0xf0d54349aDdcf704F77AE15b96510dEA15cb7952',
    keyHash: '0xAA77729D3466CA35AE8D28B3BBAC7CC36A5031EFDC430821C02BC31A238AF445',
  },
};
