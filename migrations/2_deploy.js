const fs = require('fs');

const WorkerManager = artifacts.require('./../contracts/managers/WorkerManager.sol');
//const Worker = artifacts.require('./../contracts/workers/Worker.sol');
const ItemManager = artifacts.require('./../contracts/managers/ItemManager.sol');
//const ItemRepo = artifacts.require('./../contracts/repos/ItemRepo.sol');

//const ProxyContract = artifacts.require('./../contracts/TestProxy.sol');

module.exports = async function(deployer) {

    let owner = '0x627306090abab3a6e1400e9345bc60c78a8bef57';

    let ownerOptions = {
        from: owner
        //value: '1000000000000000000', 
        //gas: 100000
    };

    // deploy worker manager
    await deployer.deploy(WorkerManager);
    let workerManagetInstance = await WorkerManager.deployed();
    await workerManagetInstance.init();

    // deploy item manager
    await deployer.deploy(ItemManager);
    let itemManagerInstance = await ItemManager.deployed();
    await itemManagerInstance.init();

    //let workerAddress = await wmInstance.createWorker



    // deploy proxy
    // await deployer.deploy(ProxyContract, marketDeployed.address);
    // let proxyDeployed = await ProxyContract.deployed();

    // let workingInstance = IMarket.at(proxyDeployed.address);
    // await workingInstance.init();
    // await workingInstance.marketInit(tokenDeployed.address);

    console.log('Worker manager address: ' + workerManagetInstance.address);
    console.log('Item manager address: ' + itemManagerInstance.address);
    console.log('Current dir: ' + __dirname);
    console.log();

    let defaultWritingPath = './abis/';
    if (!fs.existsSync(defaultWritingPath)){
        fs.mkdirSync(defaultWritingPath);
        console.log('Directory created: ', defaultWritingPath);
        console.log();
    }

    let data = {};

	data.owner = owner;
	data.address = workerManagetInstance.address;
	data.abi = workerManagetInstance.abi;

	fs.writeFile(defaultWritingPath + 'workerManager.json', JSON.stringify(data), 'utf8', function (e) {
		if (e) {
            console.log('Has error! File does not been saved!');
            console.log(e);
            console.log();
		}
	});

	data.owner = owner;
    data.address = itemManagerInstance.address;
    data.abi = itemManagerInstance.abi;

	fs.writeFile(defaultWritingPath + 'itemManager.json', JSON.stringify(data), 'utf8', function (e) {
		if (e) {
            console.log('Has error! File does not been saved!');
            console.log(e);
            console.log();
		}
	});
};