pragma solidity >=0.4.25 <0.6.0;

contract Mixtape {
  address public producer;
  address [] public rapper;

  uint public totalTip;
  uint public totalClap;
  uint public totalPlay;

  mapping(address => uint) numOfClap;
  mapping(address => uint) multiSign;
  mapping(address => bool) isRapper;

  constructor(address _producer) public{
      producer = _producer;
      totalTip = 0;
      totalClap = 0;
      totalPlay = 0;
  }

  function registerRap(address _rapper, string memory uid) public {
      require(isRapper[_rapper] != true);
      rapper.push(_rapper);
      isRapper[_rapper] = true;
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

  function distribute(address _producer, address _rapper, string memory uid) public {
      require( uint256(keccak256(abi.encodePacked(_rapper, producer, uid))) == multiSign[_rapper]);
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
      Mixtape newMixtape = new Mixtape(msg.sender);
      mixtapes.push(address(newMixtape));

  }

  function registerRap(address mixtape, string memory uid) public {
      mixtape.call(abi.encodeWithSignature("registerRap(address, string memory)", msg.sender, uid));
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

  function distribute(address mixtape, address _producer, address _rapper, string _uid) public {
      mixtape.call(abi.encodeWithSignature("distribute(address, address, uint256)", _producer, _rapper, _uid));
  }
}