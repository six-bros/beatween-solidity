pragma solidity >=0.4.25 <0.6.0;

contract Mixtape {
    address public producer;
    address[] public rappers;
  
    uint public totalTip;
    uint public totalClap;
    uint public totalPlay;
    string public uid;
    
    mapping(address => string) uidMap;
    mapping(address => uint) numOfClap;
    mapping(address => uint) multiSign;
    
  
    constructor(address _producer, string memory _uid) public{
        producer = _producer;
        totalTip = 0;
        totalClap = 0;
        totalPlay = 0;
        uid = _uid;
    }
    
    function getBalance() public returns(uint){
        return address(this).balance;
    }
  
    function _registerRapping(address _rapper) public {
        rappers.push(_rapper);
        multiSign[_rapper] = uint256(keccak256(abi.encodePacked(_rapper, producer, uid)));
    }
  
    function _saveTip(uint tip) public {
        totalTip += tip;
    }
  
    function _donation(uint rapperIndex) public payable {
        address(producer).transfer(msg.value/2);
        address(rappers[rapperIndex]).transfer(msg.value/2);
    }
  
    function _clap(address add) public {
        require(numOfClap[add] < 50);
        numOfClap[add]++;
        totalClap++;
    }
  
    function _play() public {
        totalPlay++;
    }
  
    function _distribute(address _producer, address _rapper, string memory uid) public {
        require(uint256(keccak256(abi.encodePacked(_rapper, producer, uid))) == multiSign[_rapper]);
        uint money = address(this).balance;
        address(_producer).transfer(money/2);
        address(_rapper).transfer(money/2);
    }
}  
  
contract User {
  
    address public user;
    address[] public mixtapes;
    string public uid;
  
    constructor(string memory _uid) public {
        user = msg.sender;
        uid = _uid;
    }
  
    function registerBeat() public {
        Mixtape newMixtape = new Mixtape(msg.sender, uid);
        mixtapes.push(address(newMixtape));
    }
  
    function registerRap(address mixtape) public {
        mixtape.call(abi.encodeWithSignature("_registerRapping(address)", msg.sender));
    }
  
    function donation(address mixtape, uint rapperIndex) public payable{
        require(msg.value != 0);
        mixtape.call(abi.encodeWithSignature("_saveTip(uint256)", msg.value));
        mixtape.call(abi.encodeWithSignature("_donation(uint256)", rapperIndex));
    }
  
    function clap(address mixtape) public {
        mixtape.call(abi.encodeWithSignature("_clap(address)", msg.sender));
    }
  
    function play(address mixtape) public {
        mixtape.call(abi.encodeWithSignature("_play()"));
    }
  
    function distribute(address mixtape, address _producer, address _rapper) public {
        mixtape.call(abi.encodeWithSignature("_distribute(address, address, string)", _producer, _rapper, uid));
    }
}