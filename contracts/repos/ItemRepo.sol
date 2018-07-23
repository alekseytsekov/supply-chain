pragma solidity 0.4.24;

contract ItemRepo {

    address public owner;

    mapping(address=>bool) public allowedEditors;

    // product hash, 0-... num of data changes, ipfs hash
    mapping(bytes32=>mapping(uint256=>bytes32)) public data;
    mapping(bytes32=>uint256) public numOfDataChanges;

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    modifier isEditor {
        require(allowedEditors[msg.sender]);
        _;
    }

    function init(address _owner) public {
        require(owner == address(0), "Already has owner");
        require(_owner != address(0), "Param(_owner) is null");

        owner = _owner;
        allowedEditors[_owner] = true;
    }

    function addEditor(address editor) public onlyOwner {
        require(editor != address(0));
        require(!allowedEditors[editor]);

        allowedEditors[editor] = true;
    }

    function removeEditor(address editor) public onlyOwner {
        require(editor != address(0));
        require(allowedEditors[editor]);

        allowedEditors[editor] = false;
    }


    function addUpdateItemData(bytes32[] _itemHashes, bytes32[] _ipfsHashes) public isEditor {
        require(_itemHashes.length == _ipfsHashes.length);

        for(uint256 i = 0; i < _itemHashes.length; i++){
            data[_itemHashes[i]][numOfDataChanges[_itemHashes[i]]] = _ipfsHashes[i];
            numOfDataChanges[_itemHashes[i]]++;
        }
    }

    function getItemData(bytes32 itemHash) public view returns(bytes32 _data){
        return data[itemHash][numOfDataChanges[itemHash] - 1];
    }


    function getAddress() public view returns(address){
        return address(this);
    }
}