# CardgameMarketplace

The marketplace contract CollectibleMarketPlace.sol allows a user to put up a ERC721 token for sale. The marketplace will collect a fixed commissionFee for every sale, which will be paid out to the contract owner of the marketplace every time.

The unit test does the following:
- deploy all contracts
- mint some NusToken to buyer account
- seller is to mint a NFT
- seller will call ‘approve()’ to allow marketplace to perform a transferFrom() on the NFT when needed
- seller will list his NFT for sale using ‘list()’
- buyer will call ‘approve()’ to allow marketplace to perform a transferFrom() to access his NusToken
- buyer purchases the NFT using buy()
- Check that the ownership of NFT has changed to buyer
- Check that seller received NusToken for the sale price
- Check that contract owner received NusToken for commission fee
