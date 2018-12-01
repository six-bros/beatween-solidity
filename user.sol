pragma solidity >=0.4.25 <0.6.0;

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

	modifier subOnly() {
		require(subscription[msg.sender]);
		_;
	}

	function registerBeat(address _beat) public {
		isProducer[msg.sender] = true;
		beats.push(_beat);
	}

	function registerTape(address _mixtape) public {
		isRapper[msg.sender] = true;
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