pragma solidity 0.4.24;

import "./../workers/Worker.sol";

contract WorkerManager {

    address public owner;

    event CreateWorker(bytes32 indexed _workerName, address indexed _worker);

    mapping(bytes32=>Worker) public workers; // client , worker name, worker address

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function init() public {
        require(owner == address(0), "Already has owner");

        owner = msg.sender;
    }

    function createWorker(bytes32 _workerName) public onlyOwner returns(address _workerAddress){
        workers[_workerName] = new Worker();
        workers[_workerName].init(msg.sender, _workerName);
        //workers[_workerName].addCaller(msg.sender);

        emit CreateWorker(_workerName, workers[_workerName]);

        return address(workers[_workerName]);
    }

    function getWorkerByClient(bytes32 _workerName) public view returns (address){
        return workers[_workerName];
    }
}