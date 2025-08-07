const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { ethers } = require("hardhat");
// const moment = require("moment");
// const { BN } = require("@openzeppelin/test-helpers");

describe("Validator fund stake", function() {
  async function deployContractValidatorStake() {

      [alice, validator, bob, royaltyReceiver, carl, random, newFeeAddress] = await ethers.getSigners();

      console.log("deploying...");
        const Dex = await hre.ethers.getContractFactory("Dex");
        const dex = await Dex.deploy();


        console.log("Dex contract deployed: ", dex.getAddress());

        const FlashLoanArbitrage = await hre.ethers.getContractFactory(
            "FlashLoanArbitrage"
          );
          const flashLoanArbitrage = await FlashLoanArbitrage.deploy(
            "0xc4dCB5126a3AfEd129BC3668Ea19285A9f56D15D"
          );
        
          await flashLoanArbitrage.deployed();
        
        //   console.log("Flash loan contract deployed: ", flashLoanArbitrage.getAddress());

    //   const VS = await hre.ethers.getContractFactory("validatorStake")

    //     ValidatorStake = await upgrades.deployProxy(VS, [], {
    //       initializer: "initialize",
    //       kind: "uups",
    //     })

//         const mintToken = await hre.ethers.deployContract("mintToken", ["100000000000"]);
//   sampleERC20 = await mintToken.waitForDeployment();

//       const mintToken1 = await hre.ethers.deployContract("mintToken", ["100000000000"]);
//   sampleERC20Token = await mintToken1.waitForDeployment();

  

      //   console.log("deployment", await ValidatorStake.getAddress())

        return { dex,flashLoanArbitrage, alice, bob, carl };
  }



  describe("Deployment", function () {
      it("should deploy the ValidatorStake Contract", async () => {
          let {ValidatorStake,flashLoanArbitrage, alice, bob, carl} = await deployContractValidatorStake()
      });




  });
});
