pragma solidity 0.4.24;

import "./../repos/ItemRepo.sol";

contract Worker {

    address public owner;
    address public repo;
    bytes32 public name;

    //bytes32 public expectedState;
    event DoWork(address indexed _worker);

    mapping(address=>bool) public callers;

    modifier onlyOwner {
        require (msg.sender == owner);
        _;
    }

    modifier isCaller {
        require(callers[msg.sender]);
        _;
    }

    function init(address _owner, bytes32 _name) public {
        require(_owner != address(0), "Param(_owner) is null");
        require(owner == address(0), "Already has owner");

        owner = _owner;
        name = _name;
        callers[_owner] = true;
    }

    function addCaller(address _caller) public onlyOwner {
        require(!callers[_caller], "Caller is regitered!");
        
        callers[_caller] = true;
    }

    function addRepo(address _repo) public onlyOwner {
        require(repo == address(0));
        require(_repo != address(0));

        repo = _repo;
    }

    function doWork(bytes32[] _itemHashes, bytes32[] _ipfsHashes) public {
        require(_itemHashes.length == _ipfsHashes.length);
        
        // do some work ....

        ItemRepo _repo = ItemRepo(repo);
        _repo.addUpdateItemData(_itemHashes, _ipfsHashes);

        emit DoWork(address(this));
    }
}