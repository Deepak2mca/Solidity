pragma solidity ^0.4.17;
// Sahubank.sol (note .sol extension)

// Start with Natspec comment (the three slashes)
// used for documentation - and as descriptive data for UI elements/actions

/// @title Sahubank
/// @author Deepak Sahu

/* 'contract' has similarities to 'class' in other languages like C#, Java (class variables,
inheritance, etc.) and it has function,events,properties  */

contract SahuBank { // CamelCase
    // Declare state variables outside function, persist through life of contract
    // dictionary that maps addresses to balances
    // it has private accessibility
    mapping (address => uint) private balances;
    // "private" means that other contracts can't directly query balances
    // but data is still viewable to other parties on blockchain
    address public owner;
    // 'public' makes externally readable (not writeable) by users or contracts
    // Events - publicize actions to external listeners
    event Transfer(address from, address to, uint256 _value);
    event DepositMade(address accountAddress, uint amount);
    // Constructor, can receive one or many variables here; only one allowed
    function SahuBank() public {
        // msg provides details about the message that's sent to the contract
        // msg.sender is contract caller (address of contract creator)
        owner = msg.sender;
        balances[msg.sender] = 10000;
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    function deposit() public returns (uint)  {
        balances[msg.sender] += msg.value;
        // no "this." or "self." required with state variable
        // all values set to data type's initial value by default
        DepositMade(msg.sender, msg.value); // fire event

        return balances[msg.sender];
    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    function withdraw(uint withdrawAmount) public returns (uint remainingBal) {
        //withdrawAmount must be greater then balance in account
        if(balances[msg.sender] >= withdrawAmount) {
            //deduct the amount from senderAccount
            balances[msg.sender] -= withdrawAmount;
            
            if (!msg.sender.send(withdrawAmount)) {
                // to be safe, may be sending to contract that
                // has overridden 'send' which may then fail
                balances[msg.sender] += withdrawAmount;
            }
        }

        return balances[msg.sender];
    }

    /// @notice Get balance
    /// @return The balance of the user
    // 'constant' prevents function from editing state variables;
    // allows function to run locally/off blockchain
    function balance() constant returns (uint) {
        return balances[msg.sender];
    }

    // Fallback function - Called if other functions don't match call or
    // sent ether without data
    // Typically, called when invalid data is sent
    // Added so ether sent to this contract is reverted if the contract fails
    // otherwise, the sender's money is transferred to contract
    function () {
        revert(); // throw reverts state to before call
    }
}

