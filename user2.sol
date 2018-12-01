pragma solidity >=0.4.25 <0.6.0;

import './mixtapes.sol';

contract User {
	address user;
	mapping(address => bool) isProducer;
	mapping(address => bool) isRapper;
	mapping(address => bool) subscription;
	uint subscriptionStartDate;

	address[] beats;
	address[] mixtapes;

	constructor() public {
		user = msg.sender;
	}

    function getBeatsCount() public view returns(uint beatsCount) {
        return beats.length;
    }

    function getMixtapesCount() public view returns (uint mixtapesCount) {
        return mixtapes.length;
    }

    function registerBeat() public returns(address newContract) {
        Mixtape m = new Mixtape(msg.sender);
        beats.push(m);
        return m;
    }

	modifier subOnly() {
		require(subscription[msg.sender]);
		_;
	}

	function registerTape(address _mixtape) public {
		mixtapes.push(_mixtape);
	}

	function subscribe() public payable {
		require(msg.value > 0.5 ether);
		subscription[msg.sender] = true;
		subscriptionStartDate = now;
	}

	function subExpired() public {
		require(now >= subscriptionStartDate + 30 days);
		subscription[msg.sender] = false;
	}

	function listen(address _record) public {
		// play music
		_record.playCnt++;
	}

	function listenEx(address _record) public subOnly {
		subExpired();
		require(subscription);
		// play exclusive music
		_record.playCnt++;
	}
}