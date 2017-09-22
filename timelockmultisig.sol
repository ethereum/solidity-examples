/*
The MIT License (MIT)

Copyright (c) 2016 Alex van de Sande

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


# Time Locked Multisig

This is a different twist on the Congress DAO / Multisig. Instead of every
action requiring the approval of an X number of members, instead any
transactions can be initiated by a single member, but they all will require a
minimum amount of delay before they can be executed, which varies according to
the support that transaction has. The more approvals a proposal has, the sooner
it can be executed. A member can vote against a transaction, which will mean
that it will cancel one of the other approved signatures. In a 5 members DAO,
each vote means the time to wait dimishes by 10x.

This means that if you don't have urgency, one or two signatures might be all
you need to execute any transaction. But if a single key is compromised, other
keys can delay that transaction for years, making sure that the main account is
emptied out way before that.

Transaction delays:

(Support - oppositon)/ total members => Time delay (approximate)

100% approval: 30 min
90%:           1h30
80%:           5 hours
50%:           about a week
25%:           4 months 
10%:           2 years
support=oppos: 5 years or more
-10%         18 years

*/


pragma solidity ^0.4.4;

contract owned {
    address public owner;

    function owned() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        if (msg.sender != owner) throw;
        _;
    }

    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }
}

/// @author Alex van de Sande <avsa@ethereum.org>
contract TimeLockMultisig is owned {
    Proposal[] public proposals;
    uint public numProposals;
    mapping (address => uint) public memberId;
    Member[] public members;

    event ProposalAdded(uint proposalID, address recipient, uint amount, string description);
    event Voted(uint proposalID, bool position, address voter, string justification);
    event ProposalExecuted(uint proposalID, int result, uint deadline);
    event MembershipChanged(address member, bool isMember);
    event ChangeOfRules(uint minimumQuorum, uint debatingPeriodInMinutes, int majorityMargin);

    struct Proposal {
        address recipient;
        uint amount;
        string description;
        bool executed;
        int currentResult;
        bytes32 proposalHash;
        Vote[] votes;
        mapping (address => bool) voted;
    }

    struct Member {
        address member;
        bool canVote;
        string name;
        uint memberSince;
    }

    struct Vote {
        bool inSupport;
        address voter;
        string justification;
    }

    /* modifier that allows only shareholders to vote and create new proposals */
    modifier onlyMembers {
        if (
            memberId[msg.sender] == 0 ||
            !members[memberId[msg.sender]].canVote
        )
            throw;
        _;
    }

    /* First time setup */
    function TimeLockMultisig(address founder, address[] initialMembers) payable {
        if (founder != 0) owner = founder;
        // It’s necessary to add an empty first member
        changeMembership(0, false, ''); 
        // and let's add the founder, to save a step later
        changeMembership(owner, true, 'founder');
        changeMembers(initialMembers, true);
    }

    /*make member*/
    function changeMembership(address targetMember, bool canVote, string memberName) onlyOwner {
        uint id;
        if (memberId[targetMember] == 0) {
           memberId[targetMember] = members.length;
           id = members.length++;
           members[id] = Member({member: targetMember, canVote: canVote, memberSince: now, name: memberName});
        } else {
            id = memberId[targetMember];
            Member m = members[id];
            m.canVote = canVote;
        }

        MembershipChanged(targetMember, canVote);

    }

    function changeMembers(address[] newMembers, bool canVote) {
        for (uint i = 0; i < newMembers.length; i++) {
            changeMembership(newMembers[i], canVote, '');
        }
    }

    /* Function to create a new proposal */
    function newProposal(
        address beneficiary,
        uint weiAmount,
        string jobDescription,
        bytes transactionBytecode
    )
        onlyMembers
        returns (uint proposalID)
    {
        proposalID = proposals.length++;
        Proposal p = proposals[proposalID];
        p.recipient = beneficiary;
        p.amount = weiAmount;
        p.description = jobDescription;
        p.proposalHash = keccak256(beneficiary, weiAmount, transactionBytecode);
        p.executed = false;
        ProposalAdded(proposalID, beneficiary, weiAmount, jobDescription);
        numProposals = proposalID+1;
        vote(proposalID, true, '');

        return proposalID;
    }


    /* Function to create a new proposal */
    function newProposalInEther(
        address beneficiary,
        uint etherAmount,
        string jobDescription,
        bytes transactionBytecode
    )
        onlyMembers
        returns (uint proposalID)
    {
        return newProposal(beneficiary, etherAmount * 1 ether, jobDescription, transactionBytecode);
    }

    /* function to check if a proposal code matches */
    function checkProposalCode(
        uint proposalNumber,
        address beneficiary,
        uint etherAmount,
        bytes transactionBytecode
    )
        constant
        returns (bool codeChecksOut)
    {
        Proposal p = proposals[proposalNumber];
        return p.proposalHash == keccak256(beneficiary, etherAmount, transactionBytecode);
    }

    function vote(
        uint proposalNumber,
        bool supportsProposal,
        string justificationText
    )
        onlyMembers
        returns (uint voteID)
    {
        Proposal p = proposals[proposalNumber];         // Get the proposal
        if (p.voted[msg.sender] == true) throw;         // If has already voted, cancel
        p.voted[msg.sender] = true;                     // Set this voter as having voted
        if (supportsProposal) {                         // If they support the proposal
            p.currentResult++;                          // Increase score
        } else {                                        // If they don't
            p.currentResult--;                          // Decrease the score
        }
        // Create a log of this event
        Voted(proposalNumber,  supportsProposal, msg.sender, justificationText);
    }

    function proposalDeadline(uint proposalNumber) constant returns(uint deadline) {
        Proposal p = proposals[proposalNumber];
        uint factor = 3*10**uint(6 - (5 * p.currentResult / int(members.length - 1)));
        return now + uint(factor * 1 minutes);
    }

    function executeProposal(uint proposalNumber, bytes transactionBytecode) returns (int result) {
        Proposal p = proposals[proposalNumber];
        /* Check if the proposal can be executed:
           - Has the voting deadline arrived?
           - Has it been already executed or is it being executed?
           - Does the transaction code match the proposal?
           - Has a minimum quorum?
        */

        if (
            now < proposalDeadline(proposalNumber) ||
            p.currentResult <= 0 ||
            p.executed ||
            p.proposalHash != keccak256(p.recipient, p.amount, transactionBytecode)
        )
            throw;


        p.executed = true;
        if (!p.recipient.call.value(p.amount)(transactionBytecode)) {
            throw;
        }

        // Fire Events
        ProposalExecuted(proposalNumber, p.currentResult, proposalDeadline(proposalNumber));
    }

    function () payable {}
}
