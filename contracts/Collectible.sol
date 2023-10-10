// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Collectible is ERC721 {
  constructor() ERC721("Collectible", "COL") {}
  
  address _owner = msg.sender;

  struct Card {
  uint8 strength;
  uint8 defence;
  uint8 health;
  }

  Card[] cards;
  uint256 cardCount;

  function mint(uint8 strength, uint8 defence, uint8 health) public {
    require(msg.sender == _owner);
    cards.push(Card(strength, defence, health));
    uint256 _id = cardCount++;
    _mint(msg.sender, _id);
  }

  function getCardStatsFromId(uint id) public view returns(uint8, uint8, uint8) {
    return (cards[id].strength, cards[id].defence, cards[id].health);
  }
  
  function getOwnerOfContract() public view returns (address){
      return _owner;
  }
}
