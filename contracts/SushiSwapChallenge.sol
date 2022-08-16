// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

import './interfaces/MasterChef.sol';
import './interfaces/IUniswapV2Pair.sol';
import './interfaces/IUniswapV2Factory.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import './interfaces/IUniswapV2Router02.sol';

// MasterChef creado por mi, con la pool par sushi/dai.
/// TX DE PRUEBA = 0xa4032b5fbeb36b538ead7a31dc6acd17a1d91da21540fc424b137f9f73c05000


contract SushiSwapChallenge {


    IUniswapV2Factory factory = IUniswapV2Factory(0xc35DADB65012eC5796536bD9864eD8773aBc74C4);
    MasterChef  masterChef = MasterChef(0x3fD1EA64713cF39F3c7DAC66d5c449ec7900BC87);
    IUniswapV2Router02 sushiRouter = IUniswapV2Router02(0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506);
    ERC20 sushi_token  = ERC20(0x81DB9C598b3ebbdC92426422fc0A1d06E77195ec);
    ERC20 Dai_token = ERC20(0xaD6D458402F60fD3Bd25163575031ACDce07538D);

    event Log(string message, uint value);
    event sendSLP(address pair, uint liquidity, uint pid);


    function sushiLiquiditySLP(uint _amountA, uint _amountB, uint _pid) public { 
        require(_amountA != 0 && _amountB != 0, "NO PUEDE SER CEROOOOOOOO"); 

    //SENDS TOKENS 
        uint256 allowance = IERC20(sushi_token).allowance(msg.sender, address(this));
        uint256 allowance1 = IERC20(Dai_token).allowance(msg.sender, address(this));
        require(allowance >= _amountA, "Check the token allowance");
        require(allowance1 >= _amountB, "Check the token allowance");

        if(_amountA  > 0){
            require (IERC20(sushi_token).transferFrom(msg.sender, address(this), _amountA));
            require (IERC20(Dai_token).transferFrom(msg.sender, address(this), _amountB));
        }



      //APPROVE ROUTER
        IERC20(sushi_token).approve(address(sushiRouter), _amountA);
        IERC20(Dai_token).approve(address(sushiRouter), _amountB);


    //ADD LIQUIDITY
    (uint amountA, uint amountB, uint liquidity ) =
      IUniswapV2Router02(sushiRouter)
      .addLiquidity(
        address(sushi_token),
         address(Dai_token),
        _amountA,
        _amountB,
        0,
        0,
        address(this),
       block.timestamp
      );

      emit Log("CANTIDAD SUSHII", amountA);
      emit Log("CANTIDAD DAII", amountB);
      emit Log("LIQUIDESS", liquidity);
 
    //APROVE MASTERCHEF
    (address pair) = IUniswapV2Factory(factory).getPair(address(sushi_token),address(Dai_token));
     IUniswapV2Pair(pair).approve(address(masterChef), liquidity);
     IUniswapV2Pair(pair).allowance(msg.sender,pair );
     require(pair != address(0), "pool no existe!!");

    
    //SEND TOKEN SLP
    if(liquidity > 0){
        masterChef.deposit(_pid, liquidity);

    }

      emit sendSLP(pair, liquidity, _pid );
     }


    function createPairSushiDai()public payable returns(address pair)  {
      address pairSushiDai = IUniswapV2Factory(factory).createPair(address(sushi_token),address(Dai_token));
      return pairSushiDai;
    }

  
    receive() external payable {}

  
}