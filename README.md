# Decentralized Crowdfunding Platform on Ethereum Sepolia Testnet

## Overview

This project is a decentralized crowdfunding platform built on the Ethereum Sepolia testnet. The platform allows users to create and contribute to crowdfunding campaigns, where funds are released based on milestone approvals by contributors. The smart contract is deployed on the Sepolia testnet, and users can interact with it directly via Sepolia Etherscan or Remix IDE.

## Features

- **Campaign Creation:** Users can create crowdfunding campaigns with multiple milestones.
- **Contribution Mechanism:** Contributors can send ETH to campaigns.
- **Milestone-Based Funding:** Funds are released incrementally based on milestone approvals.
- **Refunds:** If a campaign fails to meet its funding goal, contributors can claim refunds.
- **Campaign Finalization:** Campaigns can be finalized when all milestones are completed or the deadline is reached.

## Contract Details

- **Network:** Ethereum Sepolia Testnet
- **Contract Address:** `0x26dfD25e33e78eff0A89bB16F941D475a8854aA0`
- **Deployed By:** `0x63146056F37b2DCd5bfD75D1D6EcE1D1ca8C3653`
- **Deployment Transaction:** [View on Etherscan](https://sepolia.etherscan.io/tx/0x5d826167eb23f7521c72d8a72da62f6d74ba449c11010ac50e3b33fb68f3c1f5)

## Getting Started

### 1. Interacting with the Contract

You can interact with the contract using Sepolia Etherscan or Remix IDE. Below are the instructions for both methods.

### Using Sepolia Etherscan

1. **Access the Contract:**
   - Go to Sepolia Etherscan and search for the contract using the contract address: `0x26dfD25e33e78eff0A89bB16F941D475a8854aA0`.

2. **Read Contract:**
   - Click on the "Contract" tab, then "Read Contract" to view the available read-only functions.
   - Examples:
     - `getCampaignDetails(uint256 campaignId)`: Retrieves details of a specific campaign.
     - `getTotalContributions(uint256 campaignId)`: Fetches the total contributions to a campaign.

3. **Write Contract:**
   - Click on "Write Contract" to interact with the contract by creating campaigns, contributing, approving milestones, claiming refunds, and finalizing campaigns.
   - Connect your MetaMask wallet to Sepolia and ensure it has some test ETH for gas fees.
   - Examples:
     - `createCampaign(string _name, string _description, uint256 _targetAmount, uint256 _deadline, string[] _milestoneDescriptions, uint256[] _milestoneAmounts)`: Create a new campaign.
     - `contribute(uint256 _campaignId)`: Contribute ETH to a specific campaign.
     - `approveMilestone(uint256 _campaignId, uint256 _milestoneIndex)`: Approve a specific milestone.
     - `claimRefund(uint256 _campaignId)`: Claim a refund if the campaign fails.
     - `finalizeCampaign(uint256 _campaignId)`: Finalize a campaign after completion or failure.

### Using Remix IDE

1. **Connect to Sepolia:**
   - Open (https://remix.ethereum.org/#lang=en&optimize=false&runs=200&evmVersion=null&version=soljson-v0.8.26+commit.8a97fa7a.js).
   - Connect MetaMask to Remix and ensure MetaMask is on the Sepolia network.

2. **Deploy or Access the Contract:**
   - If redeploying, paste the Solidity code and deploy.
   - To interact with the deployed contract, paste the contract address in the "At Address" field and click "At Address".

3. **Interact with the Contract:**
   - Expand the contract interface to see the available functions.
   - Use the appropriate functions to create campaigns, contribute, approve milestones, claim refunds, and finalize campaigns.

### 2. Verifying the Contract

The smart contract has been verified on Sepolia Etherscan. You can view the verified source code (https://sepolia.etherscan.io/address/0x26dfD25e33e78eff0A89bB16F941D475a8854aA0).

## Project Structure

- **contracts/**
  - `CrowdfundingPlatform.sol`: Solidity smart contract for the crowdfunding platform.

- **README.md**: This file, providing an overview and instructions for interacting with the platform.

## Additional Information

- **Testing:** The contract has been tested using Remix IDE with various scenarios, including campaign creation, contribution, milestone approval, refunds, and finalization.
- **Security Considerations:** Reentrancy and overflow/underflow vulnerabilities have been mitigated using Solidity best practices.

## Deployment Information

- **Deployed on Sepolia Testnet:** The contract is deployed and available for interaction on the Sepolia testnet.
- **Contract Verification:** The contract is verified on Sepolia Etherscan, allowing public inspection and interaction.

## License

This project is licensed under the MIT License.

## Contact

For any questions or further information, feel free to contact me at (mailto: akashvn.pai@gmail.com).
