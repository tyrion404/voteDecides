const path = require('path');
const solc = require('solc');
const fs = require('fs-extra');

const buildPath = path.resolve(__dirname, 'build');
fs.removeSync(buildPath);

const campaignPath = path.resolve(__dirname, 'contracts', 'Campaign.sol');
const Source = fs.readFileSync(campaignPath, 'UTF-8');

const output = solc.compile(Source, 1).contracts;

fs.ensureDirSync(buildPath);

for(let contract in output){
    fs.outputJSONSync(
        path.resolve(buildPath, contract + '.json'),
        output[contract]
    );
}

// var input = {
//   language: 'Solidity',
//   sources: {
//     'test.sol': {
//       content: 'contract C { function f() public { } }'
//     }
//   },
//   settings: {
//     outputSelection: {
//       '*': {
//         '*': ['*']
//       }
//     }
//   }
// };
 
// var output = JSON.parse(solc.compile(JSON.stringify(input)));
 
// `output` here contains the JSON output as specified in the documentation
// for (var contractName in output.contracts['test.sol']) {
//   console.log(
//     contractName +
//       ': ' +
//       output.contracts['test.sol'][contractName].evm.bytecode.object
//   );
// }