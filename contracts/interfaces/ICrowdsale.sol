// SPDX-License-Identifier: Unlicense
pragma solidity >=0.7.0 <0.9.0;

interface ICrowdsale {

    function invest() external payable;
    function finalize() external;
    function refund() external;
    
}