pragma solidity ^0.4.0;
contract wallet{
	struct coinWallet {
	uint redCoin;
	uint greenCoin;
	}
	coinWallet myWallet;
	mapping(address => coinWallet) balances;
	function wallet(){
		balances[msg.sender].redCoin = 500;
		balances[msg.sender].greenCoin = 250;
	}
	
	function sendRed(address receiver,uint amount) returns(bool success){
	    if(balances[msg.sender].redCoin<amount)return false;
	    balances[msg.sender].redCoin-=amount;
	    balances[receiver].redCoin+=amount;
	    return true;
	}
    
    function sendGreen(address receiver,uint amount) returns(bool success){
	    if(balances[msg.sender].greenCoin<amount)return false;
	    balances[msg.sender].greenCoin-=amount;
	    balances[receiver].greenCoin+=amount;
	    return true;
	}
}