// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Hero {
    enum Class {
        Mage,
        Healer,
        Barbarian
    }

    // For creating random numbers
    function generateRandom() public view virtual returns (uint256) {
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

    function getStrength(uint256 hero) public pure returns (uint32) {
        // Shift first 2 bits (they represent the hero class(mage, healer or barbarian) then get the following 5 bits since they represent the strength )
        return uint32((hero >> 2) & 0x1F);
    }

    function getHealth(uint256 hero) public pure returns (uint32) {
        // Shift first 7 bits (they represent the hero class(mage, healer or barbarian) and strength then get the following 5 bits since they represent the health )
        return uint32((hero >> 7) & 0x1F);
    }

    function getDex(uint256 hero) public pure returns (uint32) {
        return uint32((hero >> 12) & 0x1F);
    }

    function getIntellect(uint256 hero) public pure returns (uint32) {
        return uint32((hero >> 17) & 0x1F);
    }

    function getMagic(uint256 hero) public pure returns (uint32) {
        return uint32((hero >> 22) & 0x1F);
    }

    function createHero(Class class) public payable {
        // Payable means this function can accept money
        require(msg.value >= 0.05 ether, "Please send maor money"); // require means check this and if fails return an error

        // stats are strength, health, dexterity, intellect, magic. When you create an array you need to define where it is stored
        uint256[] memory stats = new uint256[](5);

        stats[0] = 2;
        stats[1] = 7;
        stats[2] = 12;
        stats[3] = 17;
        stats[4] = 22;

        uint256 len = 5;

        // class can be 0,1 or 2 (Mage,Healer,Barbarian)
        uint256 hero = uint256(class);

        do {
            uint256 pos = generateRandom() % len; // position
            uint256 value = (generateRandom() % (13 + len)) + 1; // value of the stat (len is 5 and max is 18 so 13 is ourr magic number)

            hero |= value << stats[pos];

            // reduce length to not create a trait twice
            len--;
            stats[pos] = stats[len];
        } while (len > 0);

        addressToHeroes[msg.sender].push(hero);
    }
}
