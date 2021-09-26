import { useEffect, useState } from 'react';
import { utils } from 'ethers';
import { Balance } from './components/Balance';
import { injected } from './connectors';
import { useEagerConnect, useInactiveListener, useMoodblockToken, useWeb3 } from './hooks';
import { ConnectorNames } from './types';

// TODO: Move to constants
const MOODBLOCK_TOKEN_CONTRACT_ADDRESS = '0x0165878A594ca255338adfa4d48449f69242Eb8F';

const connectorsByName: { [connectorName in ConnectorNames]: any } = {
  [ConnectorNames.Injected]: injected,
};

function App() {
  const { connector, account, activate, active, error } = useWeb3();
  const [activatingConnector, setActivatingConnector] = useState<any>();
  const { send, call } = useMoodblockToken(MOODBLOCK_TOKEN_CONTRACT_ADDRESS);
  const [moodblock, setMoodblock] = useState<{
    name: string;
    image: string;
    description: string;
    attributes: { name: string; value: string }[];
  } | null>(null);

  useEffect(() => {
    if (activatingConnector && activatingConnector === connector) {
      setActivatingConnector(undefined);
    }
  }, [activatingConnector, connector]);

  const triedEager = useEagerConnect();

  useInactiveListener(!triedEager || !!activatingConnector);

  const connectWith = async (name: ConnectorNames) => {
    setActivatingConnector(name);
    activate(connectorsByName[name]);
  };

  const mint = async () => {
    try {
      const unitPrice = await call('getUnitPrice');
      await send('mint', {
        from: account || undefined,
        value: unitPrice,
      });
      console.log('Minting Moodblock...');
    } catch (e) {
      console.error('Could not interact with contract', e);
    }
  };

  const view = async () => {
    try {
      const totalSupply = Number(await call('totalSupply'));
      const tokenURI = await call('tokenURI', totalSupply);
      const response = await fetch(tokenURI);
      const data = await response.json();
      setMoodblock(data);
      console.log(data);
    } catch (e) {
      console.error('Could not interact with contract', e);
    }
  };

  return (
    <div className="app">
      <h1>Moodblock webapp</h1>
      {active ? '🟢' : error ? '🔴' : '🟠'} {account}
      {!active && (
        <button
          type="button"
          onClick={() => {
            connectWith(ConnectorNames.Injected);
          }}
        >
          Connect wallet
        </button>
      )}
      {active && (
        <>
          <Balance />
          <button
            type="button"
            onClick={() => {
              mint();
            }}
          >
            Mint Moodblock
          </button>
          <button
            type="button"
            onClick={() => {
              view();
            }}
          >
            View last Moodblock
          </button>
        </>
      )}
      {moodblock && (
        <div>
          <img src={moodblock.image} alt={moodblock.name} />
        </div>
      )}
    </div>
  );
}

export default App;
