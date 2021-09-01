import { task } from 'hardhat/config';
import '@nomiclabs/hardhat-waffle';

task('accounts', 'Prints the list of accounts', async (args, { ethers }) => {
  const accounts = await ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

task('balance', "Prints an account's balance")
  .addParam('account', "The account's address")
  .setAction(async (args, { ethers }) => {
    const address = ethers.utils.getAddress(args.account);
    const balance = await ethers.provider.getBalance(address);
    console.log(ethers.utils.formatUnits(balance, 'ether'), 'ETH');
  });
