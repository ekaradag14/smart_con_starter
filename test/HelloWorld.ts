import _ from '@nomiclabs/hardhat-ethers';

import { ethers } from 'hardhat';
import { expect } from 'chai';

describe('Hello World', () => {
	it('should get the hello world', async () => {
		const HW = await ethers.getContractFactory('HelloWorld'); // This is the contract name not file nae
		const hello = await HW.deploy(); //Puts the contract on the network
		await hello.deployed();

		expect(await hello.hello()).to.equal('Hello, World');
	});
});
