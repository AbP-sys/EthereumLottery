# EthereumLottery
Lottery game deployed on the ethereum blockchain

## Working

  - Lottery is started by a host
  - Anyone can participate in the lottery by paying an entrance fee
  - Host ends the lottery, a winner is selected at random from the list of all accounts that have purchased a ticket and all the funds are transferred to that account
## Demo

### Participate in an ongoing lottery:
  Note: This is purely for testing and demonstration purposes. No real value currency or tokens are being used.
  - Setup an Ethereum wallet
  - Ensure you have ETH on the Rinkeby testnet. If not, you can request some funds using a [Rinkeby faucet](https://rinkebyfaucet.com/)
  - Open the deployed contract on [Rinkeby EtherScan](https://rinkeby.etherscan.io/address/0x4a635E60b59C47CAb7B3e710064A2349c83F7bC7#readContract)
  - Check ticket price using the get_ticket_price function
  - Switch to the `write` tab and buy a ticket by spending some testnet ETH
  - Authorize transaction from your ethereum wallet 

### Host a lottery  
  - Download source code from this repository 
    
    `git clone www.github.com/AbP-sys/EthereumLottery`
  - Install [brownie](https://eth-brownie.readthedocs.io/en/stable/install.html)
  
    #### For local development:
    - Install [ganache](https://trufflesuite.com/ganache/) 
    - Open git repository and run
    `brownie run scripts/deploy.py`
    - End lottery: 
    `brownie run scripts/end_lottery.py`
  
    #### For Testnet development:
    - Create a .env file in the root folder of this project and add the following entries:
  
      ```
      export PRIVATE_KEY='0x'
      export WEB3_INFURA_PROJECT_ID=''
      export ETHERSCAN_TOKEN=''
      ```
    - Copy the private key from your testnet wallet and paste it after the `0x`
    - Get project id,:
      1. Make a free account account on www.infura.io
      2. Create a new project and copy it's project id
    - Get Etherscan token (for verifying source code on Etherscan):
      1. Make an account on www.etherscan.io
      2. Go to profile and make a new API key
    - Deploy using 
    `brownie run scripts/deploy.py --network rinkeby`
      
      where `rinkeby` is the testnet you to to deploy to such as kovan, ropsten etc.
    - End lottery: 
    `brownie run scripts/end_lottery.py --network rinkeby`
   
    All the scripts are designed to work locally or on a testnet.
    
    Note: There is no chainlink node to generate a random number when the contract is deployed locally so the the winner is always returned as 0x0000000000000000000000000000000000000000. However, for testing purposes, an [event](https://blog.chain.link/events-and-logging-in-solidity/) can be created which can be used as a mock to get a random number from the chainlink node. This issue is fixed when you deploy onto a testnet.

## Dependencies 

Note: The following dependencies have already been configured in this project. No additional installation required.

### Chainlink

Used to fetch data from outside the blockchain. This particular smart contract uses chainlink nodes to get ETH to USD prices and also provides a reliable way to generate a random number to select a winner. 

[Refer to documentation](https://docs.chain.link/) | [github repo](https://github.com/smartcontractkit/chainlink) for more info

### OpenZeppelin

Provides other reliable, commonly used functionalities in smart contracts for blockchain development. Some of the useful features include string manipulation and making functions accessible only to the owner.

[Docs](https://www.openzeppelin.com/contracts) | [Github](https://github.com/OpenZeppelin/openzeppelin-contracts)  

## Additional notes 

If the chainlink node fails to respond in time, the winner address is not updated (or is displayed as 0x0000000000000000000000000000000000000000 by default). If the transaction goes through, refreshing the etherscan page after a few minutes should display the new winner.  