import _ from '@nomiclabs/hardhat-ethers'; // To handle some ts errors
import { ethers } from 'hardhat';
// Deploy script for HelloWorld.sol
async function deploy() {
	const HelloWorld = await ethers.getContractFactory('HelloWorld');
	const hello = await HelloWorld.deploy();
	await hello.deployed();

	return hello;
}

// @ts-ignore
async function sayHello(hello) {
	console.log('Say Hello:', await hello.hello());
}

deploy().then(sayHello);
