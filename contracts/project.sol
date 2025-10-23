// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedVoting {

    // 1. DATA STRUCTURES
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    // 2. STATE VARIABLES
    
    // The address of the contract administrator (who deployed it).
    address payable public owner; 
    
    // Stores candidate data. Key is Candidate ID, Value is the Candidate struct.
    mapping(uint => Candidate) public candidates; 
    
    // Counter for candidates, which also serves as the next unique ID.
    uint public candidatesCount; 
    
    // Stores voter status. Key is Voter Address, Value is a boolean (true if voted).
    mapping(address => bool) public voters;
    
    // Flag to control the voting period.
    bool public isVotingOpen; 
    
    // Name of the election.
    string public electionName;

    // 3. CONSTRUCTOR (Initialization)
    
    // The constructor runs only once upon deployment.
    constructor(string memory _electionName) {
        // Initialize the owner to the address that deployed the contract.
        owner = payable(msg.sender); 
        
        // Set the name of the election.
        electionName = _electionName;
        
        // Initialize the election status. It must be manually opened by the admin.
        isVotingOpen = false;
        
        // candidatesCount is implicitly 0 for uint.
    }

    // ... other functions (addCandidate, startVoting, vote, etc.) go here ...
}