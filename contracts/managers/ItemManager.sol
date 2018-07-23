pragma solidity 0.4.24;

import "./../repos/ItemRepo.sol";

contract ItemManager {

    address public owner;

    event CreateRepo(bytes32 indexed _client, address indexed _repo);

    mapping(bytes32=>ItemRepo) public clientRepo;

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function init() public {
        require(owner == address(0), "Already has owner");

        owner = msg.sender;
    }

    function createRepo(bytes32 _client, address _worker) public onlyOwner returns (address _repo){
        clientRepo[_client] = new ItemRepo();
        clientRepo[_client].init(address(this));
        clientRepo[_client].addEditor(_worker);

        emit CreateRepo(_client, clientRepo[_client]);

        return address(clientRepo[_client]);
    }

    function getRepoByClient(bytes32 _client) public view returns (address){
        return clientRepo[_client];
    }
}