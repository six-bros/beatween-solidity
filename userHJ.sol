pragma solidity >=0.4.25 <0.6.0;

contract User {

    struct Mixtape {
        address payable producer;
        address payable[] rapper;

        uint totalTip;
        uint totalClap;
        uint totalPlay;

        mapping(address => uint) numOfClap;
    }

    address public user;
    address[] public beats;
    address[] public raps;

    construct() public {
        user = msg.sender;
    }

    function getBeatsCount () public returns(uint beatsCount) {
        return beats.length;
    }

    function getRapsCount () public returns(uint rapsCount) {
        return raps.length;
    }

    function registerBeat() public {
        Mixtape newMixtape = Mixtape(producer = msg.sender,
        totalTip = 0, totalClap = 0, totalPlay = 0);

        beats.push(newMixtape);
        return newMixtape;
    }

    function registerRap(address mixtape) public {
        mixtape.rapper.push(msg.sender);
    }

    function donation(address mixtape, uint rapperIndex) public payable{
        require(msg.value != 0);
        mixtape.totalTip += msg.value;
        address(mixtape.producer). transfer(msg.value/2);
        address(mixtape.rapper[rapperIndex]).transfer(msg.value/2);
    }
}