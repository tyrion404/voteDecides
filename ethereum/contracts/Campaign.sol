pragma solidity >=0.4.25;

contract CampaignFactory{
    address[] public deployedCampaigns;
    
    function createCampaign(uint256 minimum) public {
        address newCampaign = new Campaign(minimum, msg.sender);
        deployedCampaigns.push(newCampaign);
    }

    function getDeployedCampaigns() public view returns (address[]) {
        return deployedCampaigns;
    }

    
}

contract Campaign{
    struct Request{
        string description;
        uint256 value;
        address recipient;
        bool complete;
        uint256 approvalCount;
        mapping(address => bool) approvals;
    }
    
    address public manager;
    uint256 public minimumContribution;
    mapping(address => bool) public approvers;
    uint256 public approversCount;
    
    Request[] public requests;
    
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
    
    constructor(uint256 minimum, address creator) public {
        manager = creator;
        minimumContribution = minimum;
    }
    
    function Contribute() public payable{
        require(msg.value >= minimumContribution);
        approvers[msg.sender] = true;
        approversCount++;
    }
    
    function createRequest(string memory description, uint256 value, address  recipient) public restricted{
        Request memory newRequest = Request({
            description: description,
            value: value,
            recipient: recipient,
            complete: false,
            approvalCount: 0
        });
        
        requests.push(newRequest);
    }
    
    function approveRequest(uint256 index) public {
        Request storage request = requests[index];
        
        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender]);
        
        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }
    
    function finalizeRequest(uint256 index) public {
        Request storage request = requests[index];
        
        
        require(request.approvalCount > (approversCount/2));
        require(!request.complete);
        
        request.recipient.transfer(request.value);
        request.complete = true;
    }
    
}

//0.6.0

// pragma solidity >=0.6.0;

// contract CampaignFactory{
//     Campaign[] public deployedCampaigns;
    
//     function createCampaign(uint256 minimum) public {
//         Campaign newCampaign = new Campaign(minimum, msg.sender);
//         deployedCampaigns.push(newCampaign);
//     }

//     function getDeployedCampaigns() public view returns (Campaign[] memory) {
//         return deployedCampaigns;
//     }

    
// }

// contract Campaign{
//     struct Request{
//         string description;
//         uint256 value;
//         address payable recipient;
//         bool complete;
//         uint256 approvalCount;
//         mapping(address => bool) approvals;
//     }
    
//     address public manager;
//     uint256 public minimumContribution;
//     mapping(address => bool) public approvers;
//     uint256 public approversCount;
    
//     Request[] public requests;
    
//     modifier restricted() {
//         require(msg.sender == manager);
//         _;
//     }
    
//     constructor(uint256 minimum, address creator) public {
//         manager = creator;
//         minimumContribution = minimum;
//     }
    
//     function Contribute() public payable{
//         require(msg.value >= minimumContribution);
//         approvers[msg.sender] = true;
//         approversCount++;
//     }
    
//     function createRequest(string memory description, uint256 value, address payable recipient) public restricted{
//         Request memory newRequest = Request({
//             description: description,
//             value: value,
//             recipient: recipient,
//             complete: false,
//             approvalCount: 0
//         });
        
//         requests.push(newRequest);
//     }
    
//     function approveRequest(uint256 index) public {
//         Request storage request = requests[index];
        
//         require(approvers[msg.sender]);
//         require(!request.approvals[msg.sender]);
        
//         request.approvals[msg.sender] = true;
//         request.approvalCount++;
//     }
    
//     function finalizeRequest(uint256 index) public {
//         Request storage request = requests[index];
        
        
//         require(request.approvalCount > (approversCount/2));
//         require(!request.complete);
        
//         request.recipient.transfer(request.value);
//         request.complete = true;
//     }
    
// }