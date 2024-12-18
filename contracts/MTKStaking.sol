// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract MTKStaking {
    IERC20 public immutable stakingToken;
    address public owner;
    bool private locked; // Reentrancy guard
    
    struct Stake {
        uint256 amount;
        uint256 timestamp;
    }
    
    uint256 public rewardRate = 1e14; // 0.0001 tokens per second per staked token
    uint256 public rewardPool;  // Track available rewards
    
    mapping(address => Stake) public stakes;
    uint256 public totalStaked;

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardsClaimed(address indexed user, uint256 amount);
    event RewardsDeposited(address indexed depositor, uint256 amount);

    modifier noReentrant() {
        require(!locked, "No reentrancy");
        locked = true;
        _;
        locked = false;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    constructor(address _stakingToken) {
        stakingToken = IERC20(_stakingToken);
        owner = msg.sender;
    }

    function depositRewards(uint256 _amount) external {
        require(_amount > 0, "Cannot deposit 0 tokens");
        require(stakingToken.transferFrom(msg.sender, address(this), _amount), 
                "Transfer failed");
        rewardPool += _amount;
        emit RewardsDeposited(msg.sender, _amount);
    }

    function stake(uint256 _amount) external noReentrant {
        require(_amount > 0, "Cannot stake 0 tokens");
        
        // Calculate and pay any outstanding rewards
        _payRewards(msg.sender);
        
        // Update stake
        stakes[msg.sender].amount += _amount;
        stakes[msg.sender].timestamp = block.timestamp;
        totalStaked += _amount;
        
        // Transfer tokens to contract
        require(stakingToken.transferFrom(msg.sender, address(this), _amount), 
                "Transfer failed");
                
        emit Staked(msg.sender, _amount);
    }

    function withdraw(uint256 _amount) external noReentrant {
        require(_amount > 0, "Cannot withdraw 0 tokens");
        require(stakes[msg.sender].amount >= _amount, "Insufficient staked amount");
        
        // Calculate and pay any outstanding rewards
        _payRewards(msg.sender);
        
        // Update stake
        stakes[msg.sender].amount -= _amount;
        stakes[msg.sender].timestamp = block.timestamp;
        totalStaked -= _amount;
        
        // Transfer tokens back to user
        require(stakingToken.transfer(msg.sender, _amount), "Transfer failed");
        
        emit Withdrawn(msg.sender, _amount);
    }

    function claimRewards() external noReentrant {
        _payRewards(msg.sender);
    }

    function _payRewards(address _user) internal {
        uint256 rewards = calculateRewards(_user);
        if (rewards > 0) {
            require(rewards <= rewardPool, "Insufficient rewards in pool");
            stakes[_user].timestamp = block.timestamp;
            rewardPool -= rewards;
            require(stakingToken.transfer(_user, rewards), "Reward transfer failed");
            emit RewardsClaimed(_user, rewards);
        }
    }

    function calculateRewards(address _user) public view returns (uint256) {
        Stake memory userStake = stakes[_user];
        if (userStake.amount == 0) {
            return 0;
        }
        
        uint256 duration = block.timestamp - userStake.timestamp;
        return (userStake.amount * duration * rewardRate) / 1e18;
    }

    function setRewardRate(uint256 _newRate) external onlyOwner {
        rewardRate = _newRate;
    }

    function emergencyWithdraw() external onlyOwner {
        uint256 balance = stakingToken.balanceOf(address(this));
        require(stakingToken.transfer(owner, balance), "Transfer failed");
        rewardPool = 0;
    }

    // Optional: Allow transferring ownership
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "New owner is zero address");
        owner = newOwner;
    }
} 