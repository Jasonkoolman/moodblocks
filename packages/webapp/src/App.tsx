import { useEffect, useState } from 'react';
import { Balance } from './components/Balance';
import { injected } from './connectors';
import { useEagerConnect, useInactiveListener, useMoodblockFactory, useWeb3 } from './hooks';
import { ConnectorNames } from './types';

// TODO: Move to constants
const MOODBLOCK_TOKEN_CONTRACT_ADDRESS = '0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512';

const connectorsByName: { [connectorName in ConnectorNames]: any } = {
  [ConnectorNames.Injected]: injected,
};

function App() {
  const web3 = useWeb3();
  const { connector, account, activate, active, error } = web3;

  const [activatingConnector, setActivatingConnector] = useState<any>();
  const moodblockContract = useMoodblockFactory(MOODBLOCK_TOKEN_CONTRACT_ADDRESS);

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

  const interact = async () => {
    if (!moodblockContract) {
      alert('No contract found');
      return;
    }

    try {
      await moodblockContract.functions.mint();
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
        </>
      )}
    </div>
  );
}

export default App;
