pragma solidity >=0.4.25 <0.6.0;

import './openZeppelin/ERC721/ERC721.sol';
import './mixtape.sol';

contract factory {
    address[] public contracts;

    function getContractCount() public view returns(uint contractCount) {
        return contracts.length;
    }

    function newMixtape() public returns(address newContract) {
        Mixtape m = new Mixtape(msg.sender);
        contracts.push(m);
        return m;
    }
}