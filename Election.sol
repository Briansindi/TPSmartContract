// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.24;

import "./Ownable.sol";
import "./SafeMath.sol";
import "./Whitelist.sol";  // Import du contrat Whitelist

contract Election is Ownable, Whitelist {

    using SafeMath for uint256;

    // Model a Candidate
    struct Candidate {
        uint256 id;
        string name;
        uint voteCount;
    }

    // Store accounts that have voted
    mapping(address => bool) public voters;
    // Store Candidates
    mapping(uint => Candidate) public candidates;
    // Store Candidates Count
    uint public candidatesCount;

    // voted event
    event votedEvent(uint indexed _candidateId);

    // Modifier pour vérifier si l'adresse est dans la whitelist
    modifier onlyWhitelisted() {
        require(isWhitelisted(msg.sender), "Vous n'etes pas autorise a ajouter un candidat.");
        _;
    }

    function addCandidate(string memory _name) public onlyWhitelisted {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    function vote(uint _candidateId) public {
        // require that they haven't voted before
        require(!voters[msg.sender]);

        // require a valid candidate
        require(_candidateId > 0 && _candidateId <= candidatesCount);

        // record that voter has voted
        voters[msg.sender] = true;

        // update candidate vote Count
        candidates[_candidateId].voteCount++;

        // trigger voted event
        emit votedEvent(_candidateId);
    }
}
