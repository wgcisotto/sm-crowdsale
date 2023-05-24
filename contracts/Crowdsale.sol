// SPDX-License-Identifier: Unlicense

pragma solidity >=0.7.0 <0.9.0;

import "./ICrowdsale.sol";
import "./USDC.sol";

contract Crowdsale is ICrowdsale {

    event LogInsvestment(address indexed investor, uint256 value);
    event LogTokenMinted(address indexed investor, uint256 tokenAmount);
   
    uint256 public startTime;
    uint256 public endTime;
    uint256 public weiTokenPrice;
    uint256 public weiInvestmentObjective;

    mapping (address => uint256) public investmentAmountOf;
    uint256 public investmentReceived;
    uint256 public investmentRefunded;
    bool public isFinalized;
    bool public isRefundingAllowed;
    address public owner;

    // ERC20 token goes next;

    constructor (uint256 _startTime, uint256 _endTime, uint256 _weiTokenPrice, 
        uint256 _weiInvestmentObjective) {
        
        require(_startTime >= block.timestamp);
        require(_endTime > _startTime);
        require(_weiTokenPrice != 0);
        require(_weiInvestmentObjective != 0);
    
        startTime = _startTime;
        endTime = _endTime;
        weiTokenPrice = _weiTokenPrice;
        weiInvestmentObjective = _weiInvestmentObjective;

        // Initialize the token with total supply of 0

        isFinalized = false; // Is this needed? Since the default value of bool is false. 
        isRefundingAllowed = false; // Is this needed? Since the default value of bool is false. 

        owner = msg.sender;
    }


    function invest() public payable override {

    }

    function finalize() public override {

    }

    function refund() public override {

    }

}