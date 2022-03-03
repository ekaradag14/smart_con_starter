import '@nomiclabs/hardhat-ethers';
import { expect } from 'chai';
import { ethers } from 'hardhat';

// WARNING: npx hardhat node should be running for tests, (and first address should be added to .env)

describe('Hero', function () {
	async function createHero() {
		// TestHero is the copy of Hero but with no randomness
		const Hero = await ethers.getContractFactory('TestHero');
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

	it('should create the hero with the right values', async function () {
		const hero = await createHero();
		await hero.setRandom(69);

		// We are creating the a Mage and getting th first element since that is the hero
		await hero.createHero(0, {
			value: ethers.utils.parseEther('0.05'),
		});
		const h = (await hero.getHeroes())[0];

		// First we create a position on uint256 pos = generateRandom() % len; So with a random of 69, 69 % 5 = 4 (Which is magic) (First trait that will be decided)
		// Second we get the value with uint256 value = (generateRandom() % (13 + len)) + 1; 69 % 18 = 15 , 15 + 1 = 16;
		// Then length becomes minus one and goes on and on

		// Status of array while creating the hero
		// [S,H,D,I,M]
		// [S,H,D,I]
		// [S,I,D]
		// [D,I]
		// [D]
		expect(await hero.getMagic(h)).to.equal(16);
		expect(await hero.getHealth(h)).to.equal(2);
		expect(await hero.getStrength(h)).to.equal(6);
		expect(await hero.getIntellect(h)).to.equal(10);
		expect(await hero.getDex(h)).to.equal(10);
	});
});
