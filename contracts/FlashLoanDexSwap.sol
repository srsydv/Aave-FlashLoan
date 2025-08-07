// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FlashLoanArbitrage is FlashLoanSimpleReceiverBase {
    address public owner;
    IUniswapV2Router02 public uniswapRouter;
    IUniswapV2Router02 public sushiswapRouter;

    constructor(
        address _addressProvider,
        address _uniswapRouter,
        address _sushiswapRouter
    ) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider)) {
        owner = msg.sender;
        uniswapRouter = IUniswapV2Router02(_uniswapRouter);
        sushiswapRouter = IUniswapV2Router02(_sushiswapRouter);
    }

    function requestFlashLoan(address token, uint256 amount) external {
        require(msg.sender == owner, "Not owner");
        POOL.flashLoanSimple(address(this), token, amount, "", 0);
    }

    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        // Step 1: Use the flash loan to buy on Uniswap
        address ;
        path[0] = asset; // e.g., USDC
        path[1] = address(0x...); // Token to arbitrage

        IERC20(asset).approve(address(uniswapRouter), amount);
        uniswapRouter.swapExactTokensForTokens(amount, 0, path, address(this), block.timestamp);

        // Step 2: Sell on Sushiswap for more
        uint256 tokenBalance = IERC20(path[1]).balanceOf(address(this));
        IERC20(path[1]).approve(address(sushiswapRouter), tokenBalance);

        address ;
        reversePath[0] = path[1];
        reversePath[1] = asset;

        sushiswapRouter.swapExactTokensForTokens(tokenBalance, 0, reversePath, address(this), block.timestamp);

        // Step 3: Repay flash loan
        uint256 totalDebt = amount + premium;
        IERC20(asset).approve(address(POOL), totalDebt);

        return true;
    }

    function withdraw(address token) external {
        require(msg.sender == owner, "Not owner");
        uint256 bal = IERC20(token).balanceOf(address(this));
        IERC20(token).transfer(owner, bal);
    }
}
