// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CrowdfundingPlatform {
    
    enum CampaignStatus { Active, Successful, Failed }
    
    struct Milestone {
        string description;
        uint256 amount;
        bool isApproved;
        uint256 approvalCount;
        mapping(address => bool) voted;
    }

    struct Campaign {
        uint256 id;
        string name;
        string description;
        uint256 targetAmount;
        uint256 deadline;
        address payable creator;
        uint256 totalContributed;
        CampaignStatus status;
        Milestone[] milestones;
        mapping(address => uint256) contributions;
        mapping(address => bool) refundsClaimed;
        uint256 contributorCount;
    }

    uint256 public campaignCounter;
    mapping(uint256 => Campaign) public campaigns;

    event CampaignCreated(uint256 indexed campaignId, string name, uint256 targetAmount, uint256 deadline, address creator);
    event ContributionMade(uint256 indexed campaignId, address indexed contributor, uint256 amount);
    event MilestoneApproved(uint256 indexed campaignId, uint256 milestoneIndex);
    event FundsReleased(uint256 indexed campaignId, uint256 milestoneIndex, uint256 amount);
    event RefundClaimed(uint256 indexed campaignId, address indexed contributor, uint256 amount);
    event CampaignFinalized(uint256 indexed campaignId, CampaignStatus status);

    function createCampaign(
        string memory _name,
        string memory _description,
        uint256 _targetAmount,
        uint256 _deadline,
        string[] memory _milestoneDescriptions,
        uint256[] memory _milestoneAmounts
    ) public {
        require(_deadline > block.timestamp, "Deadline must be in the future");
        require(_milestoneDescriptions.length == _milestoneAmounts.length, "Milestones data mismatch");
        
        campaignCounter++;
        Campaign storage newCampaign = campaigns[campaignCounter];
        newCampaign.id = campaignCounter;
        newCampaign.name = _name;
        newCampaign.description = _description;
        newCampaign.targetAmount = _targetAmount;
        newCampaign.deadline = _deadline;
        newCampaign.creator = payable(msg.sender);
        newCampaign.status = CampaignStatus.Active;

        // Initialize milestones
        for (uint256 i = 0; i < _milestoneDescriptions.length; i++) {
            Milestone storage milestone = newCampaign.milestones.push();
            milestone.description = _milestoneDescriptions[i];
            milestone.amount = _milestoneAmounts[i];
            milestone.isApproved = false;
            milestone.approvalCount = 0;
        }
        
        emit CampaignCreated(campaignCounter, _name, _targetAmount, _deadline, msg.sender);
    }

    function contribute(uint256 _campaignId) public payable {
        Campaign storage campaign = campaigns[_campaignId];
        require(block.timestamp < campaign.deadline, "Campaign has ended");
        require(campaign.totalContributed < campaign.targetAmount, "Campaign funding goal reached");
        require(campaign.status == CampaignStatus.Active, "Campaign is not active");

        campaign.contributions[msg.sender] += msg.value;
        campaign.totalContributed += msg.value;

        if (campaign.contributions[msg.sender] == msg.value) {
            campaign.contributorCount++;
        }

        emit ContributionMade(_campaignId, msg.sender, msg.value);
    }

    function approveMilestone(uint256 _campaignId, uint256 _milestoneIndex) public {
        Campaign storage campaign = campaigns[_campaignId];
        Milestone storage milestone = campaign.milestones[_milestoneIndex];

        require(campaign.contributions[msg.sender] > 0, "Only contributors can vote");
        require(!milestone.voted[msg.sender], "You have already voted for this milestone");
        
        milestone.voted[msg.sender] = true;
        milestone.approvalCount++;

        if (milestone.approvalCount > (campaign.contributorCount / 2)) {
            milestone.isApproved = true;
            campaign.creator.transfer(milestone.amount);
            emit MilestoneApproved(_campaignId, _milestoneIndex);
            emit FundsReleased(_campaignId, _milestoneIndex, milestone.amount);
        }
    }

    function claimRefund(uint256 _campaignId) public {
        Campaign storage campaign = campaigns[_campaignId];
        require(block.timestamp >= campaign.deadline, "Campaign is still active");
        require(campaign.totalContributed < campaign.targetAmount, "Campaign was successful");
        require(!campaign.refundsClaimed[msg.sender], "Refund already claimed");
        
        uint256 contribution = campaign.contributions[msg.sender];
        require(contribution > 0, "No contributions made");

        campaign.refundsClaimed[msg.sender] = true;
        payable(msg.sender).transfer(contribution);
        
        emit RefundClaimed(_campaignId, msg.sender, contribution);
    }

    function finalizeCampaign(uint256 _campaignId) public {
        Campaign storage campaign = campaigns[_campaignId];
        require(block.timestamp >= campaign.deadline, "Campaign is still active");
        require(campaign.creator == msg.sender, "Only the campaign creator can finalize");

        if (campaign.totalContributed >= campaign.targetAmount) {
            campaign.status = CampaignStatus.Successful;
        } else {
            campaign.status = CampaignStatus.Failed;
        }

        emit CampaignFinalized(_campaignId, campaign.status);
    }

    // View functions

    function getCampaignDetails(uint256 _campaignId) public view returns (
        string memory name,
        string memory description,
        uint256 targetAmount,
        uint256 totalContributed,
        uint256 deadline,
        address creator,
        CampaignStatus status,
        uint256 milestoneCount
    ) {
        Campaign storage campaign = campaigns[_campaignId];
        return (
            campaign.name,
            campaign.description,
            campaign.targetAmount,
            campaign.totalContributed,
            campaign.deadline,
            campaign.creator,
            campaign.status,
            campaign.milestones.length
        );
    }

    function getContributorInfo(uint256 _campaignId, address _contributor) public view returns (uint256 contribution, bool refundClaimed) {
        Campaign storage campaign = campaigns[_campaignId];
        return (
            campaign.contributions[_contributor],
            campaign.refundsClaimed[_contributor]
        );
    }

    function getMilestoneStatus(uint256 _campaignId, uint256 _milestoneIndex) public view returns (
        string memory description,
        uint256 amount,
        bool isApproved,
        uint256 approvalCount
    ) {
        Milestone storage milestone = campaigns[_campaignId].milestones[_milestoneIndex];
        return (
            milestone.description,
            milestone.amount,
            milestone.isApproved,
            milestone.approvalCount
        );
    }

    function getAllCampaigns() public view returns (uint256[] memory) {
        uint256[] memory campaignIds = new uint256[](campaignCounter);
        for (uint256 i = 1; i <= campaignCounter; i++) {
            campaignIds[i - 1] = i;
        }
        return campaignIds;
    }

    function getCampaignContributors(uint256 _campaignId) public view returns (address[] memory) {
        Campaign storage campaign = campaigns[_campaignId];
        address[] memory contributors = new address[](campaign.contributorCount);
        uint256 index = 0;
        for (uint256 i = 0; i < campaignCounter; i++) {
            if (campaign.contributions[i] > 0) {
                contributors[index] = address(i);
                index++;
            }
        }
        return contributors;
    }

    function getTotalContributions(uint256 _campaignId) public view returns (uint256) {
        Campaign storage campaign = campaigns[_campaignId];
        return campaign.totalContributed;
    }
}
