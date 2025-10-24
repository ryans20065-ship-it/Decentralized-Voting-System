// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title DecentralizedVoting
 * @dev A smart contract for a simple, decentralized voting system.
 * The owner can add candidates and start/stop the voting period.
 * Voters can cast one vote each while voting is open.
 */
contract DecentralizedVoting {

    // --- Data Structures ---

    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    // --- State Variables ---

    // The address of the contract administrator (who deployed it).
    address public owner;
    
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

    // --- Events ---

    // Emitted when the voting period is started or stopped.
    event VotingStatusChanged(bool isVotingOpen);
    
    // Emitted when a new candidate is added.
    event CandidateAdded(uint id, string name);
    
    // Emitted when a vote is successfully cast.
    event VoteCast(address voter, uint candidateId);

    // --- Modifiers ---

    // Restricts a function to be callable only by the owner.
    modifier onlyOwner() {
        require(msg.sender == owner, "Only admin can call this function.");
        _;
    }

    // --- Constructor ---

    /**
     * @dev Sets the deployer as the owner and names the election.
     * @param _electionName The name of the election.
     */
    constructor(string memory _electionName) {
        owner = msg.sender;
        electionName = _electionName;
        isVotingOpen = false; // Voting is closed by default
    }

    // --- Admin Functions ---

    /**
     * @dev Adds a new candidate to the election.
     * @param _name The name of the candidate.
     */
    function addCandidate(string memory _name) public onlyOwner {
        require(bytes(_name).length > 0, "Candidate name cannot be empty.");
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
        
        emit CandidateAdded(candidatesCount, _name);
    }

    /**
     * @dev Starts the voting period.
     */
    function startVoting() public onlyOwner {
        require(!isVotingOpen, "Voting is already open.");
        isVotingOpen = true;
        
        emit VotingStatusChanged(true);
    }

    /**
     * @dev Ends the voting period.
     */
    function endVoting() public onlyOwner {
        require(isVotingOpen, "Voting is not currently open.");
        isVotingOpen = false;
        
        emit VotingStatusChanged(false);
    }

    // --- Voter Functions ---

    /**
     * @dev Allows a user to cast their vote for a specific candidate.
     * @param _candidateId The ID of the candidate to vote for.
     */
    function vote(uint _candidateId) public {
        require(isVotingOpen, "Voting is not currently open.");
        require(!voters[msg.sender], "You have already voted.");
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID.");

        // Record that this voter has voted
        voters[msg.sender] = true;
        
        // Increment the candidate's vote count
        candidates[_candidateId].voteCount++;
        
        emit VoteCast(msg.sender, _candidateId);
    }

    // --- View Functions (Read-Only) ---

    /**
     * @dev Retrieves details for all candidates.
     * @return An array of Candidate structs.
     */
    function getCandidates() public view returns (Candidate[] memory) {
        // Create a new in-memory array
        Candidate[] memory allCandidates = new Candidate[](candidatesCount);
        
        // Populate the array (loops from 1 since ID 0 is unused)
        for (uint i = 1; i <= candidatesCount; i++) {
            allCandidates[i - 1] = candidates[i];
        }
        
        return allCandidates;
    }

    /**
     * @dev Checks if a specific address has already voted.
     * @param _voterAddress The address to check.
     * @return true if the address has voted, false otherwise.
     */
    function getVoterStatus(address _voterAddress) public view returns (bool) {
        return voters[_voterAddress];
    }
}