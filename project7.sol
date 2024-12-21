// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DesignAndModelGames {
    // Owner of the contract
    address public owner;

    // Structure to store game details
    struct Game {
        uint256 id;
        string name;
        string description;
        address creator;
        uint256 price;
        bool isAvailable;
    }

    // Mapping of game ID to Game details
    mapping(uint256 => Game) public games;

    // Event to log game creation
    event GameCreated(uint256 id, string name, address creator);

    // Event to log game purchase
    event GamePurchased(uint256 id, address buyer);

    // Counter for game IDs
    uint256 private gameCounter;

    // Modifier to check if sender is owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Function to add a new game
    function addGame(string memory _name, string memory _description, uint256 _price) public {
        require(_price > 0, "Price must be greater than zero");

        gameCounter++;
        games[gameCounter] = Game(gameCounter, _name, _description, msg.sender, _price, true);

        emit GameCreated(gameCounter, _name, msg.sender);
    }

    // Function to purchase a game
    function purchaseGame(uint256 _gameId) public payable {
        Game storage game = games[_gameId];

        require(game.isAvailable, "Game is not available for purchase");
        require(msg.value == game.price, "Incorrect payment amount");

        // Transfer payment to the creator
        payable(game.creator).transfer(msg.value);

        // Mark game as unavailable
        game.isAvailable = false;

        emit GamePurchased(_gameId, msg.sender);
    }

    // Function to withdraw contract balance (only owner)
    function withdrawBalance() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    // Function to get contract balance
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

