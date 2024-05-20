// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {
    address public manager;
    address payable[] public players;
    address payable[] public currentPlayers;
    address payable public currentWinner;
    address payable public winner;
    bool public isComplete;
    bool public claimed;

    constructor() {
        manager = msg.sender;
        isComplete = false;
        claimed = false;
    }

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    function getManager() public view returns (address) {
        return manager;
    }

    function getWinner() public view returns (address payable) {
        return winner;
    }

    function status() public view returns (bool) {
        return isComplete;
    }
    
    function enter() public payable {
        require(msg.value >= 0.001 ether);
        require(!isComplete);
        players.push(payable(msg.sender));
    }
    
    function pickWinner() public restricted {
        require(players.length > 0);
        require(!isComplete);
        winner = players[randomNumber() % players.length];
        isComplete = true;
    }
    
    function claimPrize() public {
        require(msg.sender == winner);
        require(isComplete && !claimed);
        winner.transfer(address(this).balance);
        claimed = true;
    }
    
    function resetContract() public payable restricted {
    // Store the current players and winner
    currentPlayers = players;
    currentWinner = winner;

    // Reset contract state
    delete players;
    winner = payable(address(0));
    isComplete = false;
    claimed = false;

    // You can access the currentPlayers and currentWinner arrays later
}

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }
    
    function randomNumber() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, players.length)));
    }
}
