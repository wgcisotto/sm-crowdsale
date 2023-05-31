// SPDX-License-Identifier: Unlicense
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/ICrowdsale.sol";
import "./interfaces/ICrowdsaleEvents.sol";
import "./USDC.sol";

contract Crowdsale is ICrowdsale, ICrowsaleEvents, Ownable {
   
    uint256 public startTime;
    uint256 public endTime;
    uint256 public weiTokenPrice;
    uint256 public weiInvestmentObjective;

    mapping (address => uint256) public investmentAmountOf;
    uint256 public investmentReceived;
    uint256 public investmentRefunded;
    bool public isFinalized;
    bool public isRefundingAllowed;

    // ERC20 token goes next;
    USDC token;

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
        token = new USDC();
        token.pause();

        isFinalized = false; // Is this needed? Since the default value of bool is false. 
        isRefundingAllowed = false; // Is this needed? Since the default value of bool is false. 
    }


    function invest() public payable override {
        require(isValidInvestment(msg.value), "Invalid amount invested.");
        require(isWithinCrowdsalePeriod(), "Invalid period.");

        address investor = msg.sender;
        uint256 investment = msg.value;

        investmentAmountOf[investor] += investment;
        investmentReceived += investment;

        assignTokens(investor, investment);
        emit LogInsvestment(investor, investment);

    }

    function finalize() onlyOwner public override {
        require(!isFinalized, "Already finalized");
        
        bool isCrowdsaleComplete = block.timestamp > endTime;
        bool objectiveMet = investmentReceived >= weiInvestmentObjective;

        if (isCrowdsaleComplete) {
            if (objectiveMet) {
                token.unpause();
            } else {
                isRefundingAllowed = true;
            }
            isFinalized = true;
        }

    }

    function refund() public override {
        require(isRefundingAllowed, "Not allowed to refund");

        address investor = msg.sender;
        uint256 investment = investmentAmountOf[investor];
        if (investment == 0) {
            revert();
        }
        investmentAmountOf[investor] = 0;
        investmentRefunded += investment;
        emit Refund(investor, investment);
        (bool sent, ) = investor.call{value: investment}("");
        require(sent, "failed to send Ether");
    }

    //Internal infuncions
    function assignTokens(address _beneficiary, uint256 _investment) internal {
        uint256 _numberOfTokens = calculateNumberOfTokens(_investment);
        //TODO: CHANGE HERE: instead of pausable create a releasable token. 
        token.unpause();
        token.mint(_beneficiary, _numberOfTokens);
        token.pause();
    }

    function calculateNumberOfTokens(uint256 _investment) internal view returns(uint256) {
        return _investment / weiTokenPrice;
    }

    //Validationsshiven
    function isValidInvestment(uint256 _investment) internal pure returns(bool) {
        return _investment != 0;
    }

    function isWithinCrowdsalePeriod() internal view returns(bool) {
        return block.timestamp >= startTime && block.timestamp <= endTime;
        
    }

}