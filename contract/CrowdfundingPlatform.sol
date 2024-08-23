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

        for (uint256 i = 0; i < _milestoneDescriptions.length; i++) {
            newCampaign.milestones.push(Milestone({
                description: _milestoneDescriptions[i],
                amount: _milestoneAmounts[i],
                isApproved: false,
                approvalCount: 0
            }));
        }
        
        emit CampaignCreated(campaignCounter, _name, _targetAmount, _deadline, msg.sender);
    }

    