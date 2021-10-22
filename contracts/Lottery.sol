pragma solidity ^0.8.9;

contract Lottery{
    address public manager;
    address[] public players;
    
    constructor() {
        manager = msg.sender;
    }
    
    function enter() public payable {
        require(msg.value > .01 ether);
        players.push(msg.sender);
    }
    
    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
    }
    
    function lot() public view returns (uint) {
        return address(this).balance;
    }
    
    function pickWinner() restricted public payable returns(address){
        address winner = players[(random() % players.length)];
        payable(winner).transfer(address(this).balance);
        players = new address[](0);
        return winner;
    }
    
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
    
    function getPLayers() public view returns(address [] memory) {
        return players;
    }
    
}