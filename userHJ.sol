pragma solidity ^0.4.25;

contract Mixtape {
    address public producer;
    address[] public rappers;

    uint public totalTip;
    uint public totalClap;
    uint public totalPlay;
    string public uid;


    mapping(address => uint) numOfClap;
    mapping(address => uint) multiSign;
    mapping(address => string) rapperUid;

    constructor(address _producer, string memory _uid) public{
        producer = _producer;
        totalTip = 0;
        totalClap = 0;
        totalPlay = 0;
        uid = _uid;
    }

    modifier haveRap() {
        require(rappers.length != 0);
        _;
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function _registerRapping(address _rapper, string _rapperUid) public {
        rappers.push(_rapper);
        rapperUid[_rapper] = _rapperUid;
        multiSign[_rapper] = uint256(keccak256(abi.encodePacked(_rapper, producer, uid, _rapperUid)));
    }

    function _saveTip(uint tip) public {
        totalTip += tip;
    }

    function _donation(uint rapperIndex, uint tip) public payable {
        totalTip += tip;
      //   producer.transfer(msg.value/2);
      //   rappers[rapperIndex].transfer(msg.value/2);
    }

    function _clap(address add) public {
        require(numOfClap[add] < 50);
        numOfClap[add]++;
        totalClap++;
    }

    function _play() public {
        totalPlay++;
    }

    function _distribute(address _producer, address _rapper, string _producerUid, string memory _rapperUid) public
     haveRap {
        require(uint256(keccak256(abi.encodePacked(_rapper, producer, _producerUid, _rapperUid))) == multiSign[_rapper]);
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
        mixtape.call(abi.encodeWithSignature("_registerRapping(address,string)", msg.sender, uid));
    }

    function donation(address mixtape, uint rapperIndex) public payable{
        require(msg.value != 0);
        mixtape.transfer(msg.value);
        mixtape.call(abi.encodeWithSignature("_donation(uint256, uint256)", rapperIndex, msg.value));
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