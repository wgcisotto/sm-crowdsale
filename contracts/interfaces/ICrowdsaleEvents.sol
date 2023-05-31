// SPDX-License-Identifier: Unlicense
pragma solidity >=0.7.0 <0.9.0;

interface ICrowsaleEvents {
    
    event LogInsvestment(
        address indexed investor, 
        uint256 value
    );
    
    event LogTokenAssignment(
        address indexed investor, 
        uint256 tokenAmount
    );
    
    event Refund(
        address indexed investor, 
        uint256 value
    );

}