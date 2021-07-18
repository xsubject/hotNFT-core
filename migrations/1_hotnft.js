const HotNFT = artifacts.require("HotNFT");

module.exports = function (deployer) {
  deployer.deploy(HotNFT);
};
