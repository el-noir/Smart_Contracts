// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract VotingSystem{
    address public owner;
    struct Candidate{
        string name;
        uint voteCount;
    }

    Candidate[] public candidates;

    mapping(address=>bool) public hasVoted;

    constructor (){
             owner= msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender==owner, "Not an owner");
        _;
    }

    function addCandidate(string memory _name) public onlyOwner {
        candidates.push(Candidate(_name, 0));
    }

    function vote(uint _candidateIndex) public {
        require(!hasVoted[msg.sender], "Already voted");
        require(_candidateIndex < candidates.length, "Invalid Candidate");

        candidates[_candidateIndex].voteCount++;
        hasVoted[msg.sender]= true;
    }
    function getTotalVotes(uint _candidateIndex) public view returns (uint){
        require(_candidateIndex <candidates.length, "Invalid Candidate");
        return candidates[_candidateIndex].voteCount;
    }
    function getCandidate(uint _candidateIndex) public view returns (string memory name, uint votes){
     require(_candidateIndex<candidates.length, "Invalid Candidate");
     Candidate memory c= candidates[_candidateIndex];
     return (c.name, c.voteCount);
    }
    function getCandidatesCount() public view returns (uint){
        return candidates.length;
    }
}