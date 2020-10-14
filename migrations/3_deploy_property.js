const MyLandContract = artifacts.require("PropertyTitle");

module.exports = function (deployer) {
    deployer.deploy(MyLandContract);
};
