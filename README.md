# BlockchainEMR 


## Introduction
The aim of this framework is to create a blockchain based Electronic Health Record management application. This application is indented to demonstrate granular access controls, automated charging and medical record management using blockchain technology.

Patient can perform the following - Login/register using Metamask, upload Patient records, pay Dr fees, provide and revoke access to own medical records and Access own Patients records  

Doctor can perform the following - Login/register using Metamask, Access Patients records, provide diagnosis and charge Patients. 



<!-- TABLE OF CONTENTS -->
## Application Demo

[![BlockChainEMR Demo](https://user-images.githubusercontent.com/118387534/205760578-0ad96333-fbbb-4db0-8f09-b820244fd903.png)](https://youtu.be/PaMTSp-VOoo)


## Installation

The projects requires Node.JS, Ganache, npm and metqmask to work. 

Instructions to install all dependencies
### Node .JS modules

PowerShell
Change your execution policy of powershell
'Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass'

Download and Install Node JS
https://nodejs.org/en/download/

1. Enable install of necessary tools and Chocolatey

<img width="429" alt="Node JS install" src="https://user-images.githubusercontent.com/118387534/205761273-d195d7d2-c313-49d9-abaa-ecbddfcc5e86.png">


2. Move to the project directory and open it in your terminal.
3. Run `npm install` to install project dependenccties.
4. Make sure following Enviornment variable paths are added 
   Node .JS - C:\Program Files\nodejs\

<img width="1466" alt="Enviornment variable" src="https://user-images.githubusercontent.com/118387534/205762935-dda52889-411c-4f1c-900e-baa3b8d29f44.png">

### Ganache

1. Go to [Ganache homepage](https://truffleframework.com/ganache) and download. 
2. If you are on Linux, you must have received an _.appimage_ file. Follow installation instructions available [here.](https://itsfoss.com/use-appimage-linux/)

### IPFS

1. Go to the [github page](https://github.com/ipfs/ipfs-desktop) of IPFS and install IPFS Desktop


### Local server

1. Install Node lite-server by running the following command on your terminal `npm install -g lite-server`

### Metamask

1. Metamask is a browser extension available for Google Chrome, Mozilla Firefox and Brave Browser.
2. Go to the this [link](http://metamask.io/) and add Metamask to your browser.


## Getting the dApp running

### Configuration

#### 1. Ganache
  - Open Ganache and click on settings in the top right corner.
  - Under **Server** tab:
    - Set Hostname to 127.0.0.1 -lo
    - Set Port Number to 8545
    - Enable Automine
  - Under **Accounts & Keys** tab:
    - Enable Autogenerate HD Mnemonic

#### 2. IPFS
  - Fire up your terminal and run `ipfs init`
  - Then run 
    ```
    ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin "['*']"
    ipfs config --json API.HTTPHeaders.Access-Control-Allow-Credentials "['true']"
    ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods "['PUT', 'POST', 'GET']"
    ```
   - if you're getting errors moddify in IPFS settings 

<img width="756" alt="IPFS modify" src="https://user-images.githubusercontent.com/118387534/205764016-5a33440c-f14a-45ac-a73f-7ca1d58fd9d8.png">


#### 3. Metamask


  - After installing Metamask, click on the metamask icon on your browser.
  - Create a new wallet
  - Connect metamask to localhost:8485
  - You can add funds to Metamask by click on import accounts
  - Select any account from ganache and copy the private key to import account into metaMask

<img width="313" alt="image" src="https://user-images.githubusercontent.com/118387534/205764410-67881381-e1d2-4621-a3eb-21b9eeda43fb.png">

<img width="1030" alt="image" src="https://user-images.githubusercontent.com/118387534/205764892-77adb891-f663-423c-b3f5-33882c734e01.png">

## Smart Contract

#### 1. Starting your local development blockchain
  - Open Ganache.
  - Make sure to configure it the way mentioned above.


### Download and copy all files from this application into a folder 
1. Using privileged CMD execute the following from BlockchainEMR/app folder  
3. Install Truffle using `npm install truffle -g`
4. Compile Contracts using `truffle compile`
5. Deploy contracts using `truffle migrate`
6. Copy deployed contract address to '/YOUR_PROJECT_DIRECTORY/app/js/src/app.js'

```js
// app/src/app.js  line number 11
var agentContractAddress = '0x75E115394aacC7c6063E593B9292CB9417E4cbeC';
```
<img width="1028" alt="image" src="https://user-images.githubusercontent.com/118387534/205766202-8c1ea1e3-1593-4294-b8f1-535cc39c323c.png">


7. If you change contents of any contract , replace existing deployment using `truffle migrate --reset`
*** Note :  reset of the contract will change the contract Address which needs to be updated in src/app.js

### Running the dApp


#### 1. Starting IPFS 
  - Start the IPFS Desktop Application
  - Ensure settings are as described above
  
#### 2. Start a local server
  - Open a new terminal window and navigate to `/YOUR_PROJECT_DIRECTORY/app/`.
  - Run `npm start`.
  - Open `localhost:3000` on your browser.
  - That's it! The dApp is up and running locally.
  - You can create accounts and interact with the application
