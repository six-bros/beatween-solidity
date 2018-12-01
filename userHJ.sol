pragma solidity >=0.4.25 <0.6.0;

contract Mixtape {
    address payable producer;
    address payable[] rapper;

    uint public totalTip;
    uint public totalClap;
    uint public totalPlay;

    mapping(address => uint) numOfClap;
    
    constructor(address payable _producer) public{
        producer = _producer;
        totalTip = 0;
        totalClap = 0;
        totalPlay = 0;
    }
    
    function registerRap(address payable _rapper) public {
        rapper.push(_rapper);
    }
    
    function saveTip(uint tip) public {
        totalTip += tip;
    }
    
    function donation(uint rapperIndex) public payable {
        address(producer).transfer(msg.value/2);
        address(rapper[rapperIndex]).transfer(msg.value/2);
    }
    
    function clap(address add) public {
        require(numOfClap[add] < 50);
        numOfClap[add]++;
        totalClap++;
    }
    
    function play() public {
        totalPlay++;
    }
}

contract User {

    address public user;
    address[] public mixtapes;
    

    constructor() public {
        user = msg.sender;
    }

    function registerBeat() public {
        Mixtape newMixtape = new Mixtape(msg.sender);
        mixtapes.push(address(newMixtape));
        
    }

    function registerRap(address mixtape) public {
        mixtape.call(abi.encodeWithSignature("registerRap(address payable", msg.sender));
    }

    function donation(address mixtape, uint rapperIndex) public payable{
        require(msg.value != 0);
        mixtape.call(abi.encodeWithSignature("saveTip(uint256)", msg.value));
        mixtape.call(abi.encodeWithSignature("donation(uint256)", rapperIndex));
    }
    
    function clap(address mixtape) public {
        mixtape.call(abi.encodeWithSignature("clap(address)", msg.sender));
    }
    
    function play(address mixtape) public {
        mixtape.call(abi.encodeWithSignature("play()"));
    }
}