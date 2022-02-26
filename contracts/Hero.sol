// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Hero {
    enum Class {
        Mage,
        Healer,
        Barbarian
    }

    // For creating random numbers
    function generateRandom() public view returns (uint256) {
        return
            uint256(
                keccak256(abi.encodePacked(block.difficulty, block.timestamp))
            );
    }

    //address is wallet address trying to contact contract
    mapping(address => uint256[]) addressToHeroes;

    //public bc this can be accessed from outside
    //view bc this is read-only
    //memory because this reaturns a value created in the function (while storage means a value in the contract, we can techinaclly use storage here as well but we will use memory)
    function getHeroes() public view returns (uint256[] memory) {
        return addressToHeroes[msg.sender];
    }

    function createHero(Class class) public payable {
        // Payable means this function can accept money
        require(msg.value >= 0.05 ether, "Please send maor money"); // require means check this and if fails return an error

    // stats are strength, health, dexterity, intellect, magic
        uint[] stats = new uint[](5);

        stats[0] = 2;
        stats[1] = 7;
        stats[2] = 12;
        stats[3] = 17;
        stats[4] = 22;

        uint len = 5;
        // class can be 0,1 or 2 (Mage,Healer,Barbarian) 
        uint hero = uint(class);

        do{
            uint pos = generateRandom() % len; // position
            uint value = generateRandom() % (13 + len) + 1 // value of the stat (len is 5 and max is 18 so 13 is ourr magic number)

            hero |= value << stats[pos];

            len--;
             stats[pos] = stats[len];
        } while( len > 0);


        addressToHeroes[msg.sender].push(hero);
    }
}
