import '@nomiclabs/hardhat-ethers';
import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('Hero', function () {
	async function createHero() {
		const Hero = await ethers.getContractFactory('Hero');
		const deployProcess = await Hero.deploy();
		await deployProcess.deployed();

		return deployProcess;
	}

	let hero;

	before(async function () {
		hero = await createHero();
	});

	it('should get a zero hero array', async function () {
		let heroes = await hero.getHeroes();

		expect(heroes).to.deep.equal([]);
	});
	it('should fail at creating hero cause of payment', async function () {
		let e;

		try {
			//0 means Mage in Hero.sol
			await hero.createHero(0, {
				value: ethers.utils.parseEther('0.0499999999'),
			});
		} catch (err) {
			e = err;
		}

		expect(e.message.includes('Please send maor money')).to.equal(true);
	});
});
