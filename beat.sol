pragma solidity >=0.4.25 <0.6.0;

contract Beat {
    address producer;

    constructor () public {
    	producer = msg.sender;
    }

    function download() public {

	}
}