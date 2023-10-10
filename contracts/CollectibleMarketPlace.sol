// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract CollectibleMarketPlace {

    //references to NFT and ERC20 token
    IERC721 collectibleContract;
    IERC20 erc20Contract;

    uint256 public comissionFee;
    address _owner = msg.sender;

    //card listings
    mapping(uint256 => mapping(address => uint256)) cardPrice;

    constructor(IERC721 collectibleAddress, IERC20 ercAddress ,uint256 fee) {
        collectibleContract = collectibleAddress;
        erc20Contract = ercAddress;
        comissionFee = fee;
    }

    //list a dice for sale. Price needs to be >= value + fee

    function list(uint256 cardId, uint256 price) public {
        require(msg.sender == getCardOwner(cardId));
        require(collectibleContract.getApproved(cardId) == address(this));
        cardPrice[cardId][getCardOwner(cardId)] = price + comissionFee;
    }

    function unlist(uint256 cardId) public {
        require(msg.sender == getCardOwner(cardId));
        cardPrice[cardId][getCardOwner(cardId)] = 0;
    }

    // get price of dice
    function getPrice(uint256 id) public view returns (uint256) {
        return cardPrice[id][getCardOwner(id)];
    }

    // Buy the dice at the requested price
    function buy(uint256 id) public  payable {        
        uint256 price = cardPrice[id][getCardOwner(id)];
        require(price != 0, "Not listed");
        cardPrice[id][getCardOwner(id)] = 0;

        erc20Contract.transferFrom(msg.sender, _owner, comissionFee);
        erc20Contract.transferFrom(msg.sender, getCardOwner(id), (price - comissionFee));
        collectibleContract.transferFrom(getCardOwner(id), msg.sender, id);
    }
    
    function getContractOwner() public view returns(address) {
        return _owner;
    }

    function getCardOwner(uint256 cardId) public view returns(address){
        return collectibleContract.ownerOf(cardId);
    }

}
