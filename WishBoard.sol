// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract WishBoard {
    struct Wish {
        address sender;
        string message;
        uint256 timestamp;
    }

    Wish[] public wishes;

    address public owner;
    
    uint256 public wishFee = 0.001 ether;

    event NewWish(address indexed sender, string message, uint256 timestamp);

    constructor() {
        owner = msg.sender;
    }

    function addWish(string memory _message) public payable {
        require(bytes(_message).length > 0, "Pesan tidak boleh kosong!");
        require(msg.value >= wishFee, "Harus membayar 0.001 BOT untuk mengirim pesan");
        
        wishes.push(Wish(
            msg.sender,
            _message,
            block.timestamp
        ));

        emit NewWish(msg.sender, _message, block.timestamp);
    }

    function getAllWishes() public view returns (Wish[] memory) {
        return wishes;
    }

    function withdrawBOT() public {
        require(msg.sender == owner, "Hanya owner yang bisa menarik dana");
        uint256 balance = address(this).balance;
        payable(owner).transfer(balance);
    }
}