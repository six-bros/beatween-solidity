pragma solidity >=0.4.25 <0.6.0;

contract Mixtape {
    address payable producer;
    address payable[] rapper;

    uint public totalTip;
    uint public totalClap;
    uint public totalPlay;

    mapping(address => uint) numOfClap;
    mapping(address => uint) multiSign;
    
    constructor(address payable _producer) public{
        producer = _producer;
        totalTip = 0;
        totalClap = 0;
        totalPlay = 0;
    }
    
    function registerRap(address payable _rapper, uint uid) public {
        rapper.push(_rapper);
        multiSign[_rapper] = uint256(keccak256(abi.encodePacked(_rapper, producer, uid)));
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
    
    function distribute(address payable _producer, address payable _rapper, uint uid) public {
        require( uint256(keccak256(abi.encodePacked(_rapper, producer, uid))) == multiSign[_rapper]);
        uint money = address(this).balance;
        address(_producer).transfer(money/2);
        address(_rapper).transfer(money/2);
    }
    
    
    
}

contract User {

    address public user;
    address[] public mixtapes;
    uint uid;
    

    constructor(uint _uid) public {
        user = msg.sender;
        uid = _uid;
    }

    function registerBeat() public {
        Mixtape newMixtape = new Mixtape(msg.sender);
        mixtapes.push(address(newMixtape));
        
    }

    function registerRap(address mixtape) public {
        mixtape.call(abi.encodeWithSignature("registerRap(address payable, uint256)", msg.sender, uid));
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
    
    function distribute(address mixtape, address _producer, address _rapper, uint _uid) public {
        mixtape.call(abi.encodeWithSignature("distribute(address payable, address payable, uint256)", _producer, _rapper, _uid));
    }
}