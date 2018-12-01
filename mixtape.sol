pragma solidity >=0.4.25 <0.6.0;

import '/ERC721/ERC721.sol'
import './user.sol';

pragma solidity >=0.4.25 <0.6.0;

// import './user.sol';

contract Mixtape {
    address payable producer;
    address payable rapper;

    uint public clapNum;
    uint public downloadNum;
    uint public totalBalance;
    
    mapping(address => bool) public downloaded;
    mapping(address => uint) public clapped;
    
    constructor (address payable _producer, address payable _rapper) public {
        producer = _producer;
        rapper = _rapper;
        clapNum = 0;
        downloadNum = 0;
    }

    // modifier onlyRapper() {
    //     require(address(msg.sender).isRapper[msg.sender]);
    //     _;
    // }

    // function download() public {
    //     require(downloaded[msg.sender] == false);
    //     downloadNum++;
    //     downloaded[msg.sender] = true;
    // }

    function giveClap() public {
        require(clapped[msg.sender] < 50);
        clapped[msg.sender]++;
        clapNum++;
    }

    function tip() public payable {
        totalBalance += msg.value;
        address(producer).transfer(msg.value/2);
        address(rapper).transfer(msg.value/2);
    }
}