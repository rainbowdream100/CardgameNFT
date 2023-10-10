const Collectible = artifacts.require("Collectible");
const NusToken = artifacts.require("NusToken");
const CollectibleMarketPlace = artifacts.require("CollectibleMarketPlace");


contract("Collectible", accounts => {
  let collectible;
  let token;
  let marketplace;
  let listPrice = 2000;
  let fee = 100;  //set by platform
  let startingBal = 3000;
  const platform = accounts[0];
  const user1 = accounts[1];
  const user2 = accounts[2];

  it("Create first collectible for user1", () =>
      Collectible.deployed()
      .then(_inst => {
        collectible = _inst;
        return collectible.mint(10,5,8);
      }).then(() => {
        return collectible.transferFrom(platform, user1, 0);
      }).then(() => {
        return collectible.ownerOf.call(0);
      }).then(rsl => {
        assert.equal(rsl.valueOf(), user1);
      })
  );

  it("user1 able to list card0 on sale", () =>
      CollectibleMarketPlace.deployed()
      .then((_inst) => {
        marketplace = _inst;
        return collectible.approve(marketplace.address, 0, {from: user1});
      }).then(() => {
        return marketplace.list(0, listPrice, {from: user1});
      }).then(() => {
        return marketplace.getPrice.call(0);
      }).then((rsl) => {
        assert.equal(rsl.valueOf(), listPrice + fee);
      })
  );

  it("mint tokens to user2", () =>
    NusToken.deployed()
      .then((_inst) => {
        token = _inst;
        return token.mint(user2, startingBal);
      }).then(() => {
        return token.balanceOf.call(user2);
      }).then((rsl) => {
        assert.equal(rsl.valueOf(), startingBal);
      })
  );

  it("user2 buys card0 from user1 via the marketplace", () =>
      token.approve(marketplace.address, listPrice + fee, {from: user2})
      .then(() => {
        return marketplace.buy(0, {from: user2});
      }).then(() => {
        return collectible.ownerOf.call(0);
      }).then((rsl) => {
        assert.equal(rsl.valueOf(), user2);
        return token.balanceOf.call(user2);
      }).then((rsl) => {
        assert.equal(rsl.valueOf(), startingBal - listPrice - fee);
        return token.balanceOf.call(user1);
      }).then((rsl) => {
        assert.equal(rsl.valueOf(), listPrice);
        return token.balanceOf.call(platform);
      }).then((rsl) => {
        assert.equal(rsl.valueOf(), fee);
      })
  )
});
