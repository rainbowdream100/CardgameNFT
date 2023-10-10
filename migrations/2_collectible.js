const Collectible = artifacts.require("Collectible");
const NusToken = artifacts.require("NusToken");
const CollectibleMarketPlace = artifacts.require("CollectibleMarketPlace");

module.exports = function(deployer, network, accounts) {
  const platform = accounts[0];
  let collectibleInstance;
  let tokenInstance;

  return deployer
    .then(() => {
        return deployer.deploy(Collectible, {from: platform});
    }).then((_inst) => {
        collectibleInstance = _inst;
        return deployer.deploy(NusToken, {from: platform});
    }).then((_inst) => {
        tokenInstance = _inst;
        return deployer.deploy(CollectibleMarketPlace,
                              collectibleInstance.address,
                              tokenInstance.address,
                              100,
                              {from: platform});
    });
};
