const fs = require('fs');
const vm = require('vm');

function include(path) {
  const code = fs.readFileSync(path, 'utf-8');
  vm.runInThisContext(code, path);
}

include('../js/genetic.class.js');
const genetic = new Genetic();
genetic.pushNodesRandomGenes({
  nodeMax: 10, geneMax: 10, min: 0, max: 9,
});

console.log(genetic.nodes);