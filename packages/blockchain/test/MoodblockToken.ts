import { ethers } from 'hardhat';
import { Signer } from 'ethers';
import { expect } from 'chai';

describe('MoodblockToken', function () {
  let accounts: Signer[];

  beforeEach(async function () {
    accounts = await ethers.getSigners();
  });

  it('should do something right', async function () {
    // Do something with the accounts
    expect(true).to.equal(true);
  });
});
