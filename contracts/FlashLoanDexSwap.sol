// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FlashLoanDexSwap is FlashLoanSimpleReceiverBase {
    address public owner;
    IUniswapV2Router02 public uniswapRouter;
    IUniswapV2Router02 public sushiswapRouter;

    constructor(
        address _provider,
        address _uniswapRouter,
        address _sushiswapRouter
    )
        FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_provider))
    {
        owner = msg.sender;
        uniswapRouter = IUniswapV2Router02(_uniswapRouter);
        sushiswapRouter = IUniswapV2Router02(_sushiswapRouter);
    }

    function requestFlashLoan(address token, uint256 amount) external {
        require(msg.sender == owner, "Only owner");
        POOL.flashLoanSimple(address(this), token, amount, "", 0);
    }

    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        require(msg.sender == address(POOL), "Caller must be pool");
        require(initiator == address(this), "Only this contract can initiate");

        // Define the swap path: USDC -> DAI on Uniswap
        address ;
        path[0] = asset; // USDC
        path[1] = 0x...; // DAI (replace with real DAI on Sepolia or mock)

        // Approve Uniswap to spend USDC
        IERC20(asset).approve(address(uniswapRouter), amount);

        // Swap USDC -> DAI on Uniswap
        uniswapRouter.swapExactTokensForTokens(
            amount,
            0,
            path,
            address(this),
            block.timestamp
        );

        // Get DAI balance
        uint256 daiBalance = IERC20(path[1]).balanceOf(address(this));

        // Approve Sushiswap to spend DAI
        IERC20(path[1]).approve(address(sushiswapRouter), daiBalance);

        // Reverse path: DAI -> USDC
        address ;
        reversePath[0] = path[1];
        reversePath[1] = asset;

        // Swap back DAI -> USDC on Sushiswap
        sushiswapRouter.swapExactTokensForTokens(
            daiBalance,
            0,
            reversePath,
            address(this),
            block.timestamp
        );

        // Final balance of USDC
        uint256 finalUSDC = IERC20(asset).balanceOf(address(this));
        uint256 totalDebt = amount + premium;

        require(finalUSDC >= totalDebt, "No profit, revert");

        // Repay Aave
        IERC20(asset).approve(address(POOL), totalDebt);

        return true;
    }

    function withdraw(address token) external {
        require(msg.sender == owner, "Not owner");
        uint256 bal = IERC20(token).balanceOf(address(this));
        IERC20(token).transfer(owner, bal);
    }
}
