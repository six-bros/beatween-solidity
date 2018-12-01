pragma solidity >=0.4.25 <0.6.0;

import './openZeppelin/ERC721/ERC721.sol';
import './user.sol';

contract Mixtape {
    address payable producer;
    address payable rapper;

    uint public totalBalance;
    
    mapping(address => uint) public clapped;
    
    constructor (address payable _producer, address payable _rapper) public {
        producer = _producer;
        rapper = _rapper;
        clapNum = 0;
        downloadNum = 0;
    }

    function giveClap() public {
        require(clapped[msg.sender] < 50);
        clapped[msg.sender]++;
        clapNum++;
    }

    function tip() public payable {
		require(msg.value != 0);
        totalBalance += msg.value;
        address(producer).transfer(msg.value/2);
        address(rapper).transfer(msg.value/2);
    }
}