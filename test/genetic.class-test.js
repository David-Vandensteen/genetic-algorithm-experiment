/* global Genetic */
const fs = require('fs');
const vm = require('vm');
const tap = require('tap');

function include(path) {
  const code = fs.readFileSync(path, 'utf-8');
  vm.runInThisContext(code, path);
}

include('../js/genetic.class.js');
const genetic = new Genetic();

tap.ok(new Genetic(), 'new Genetic');
tap.ok(genetic.pushNode(), 'genetic.pushNode');
tap.ok(genetic.pushNodesRandomGenes({
  nodeMax: 10, geneMax: 10, min: 0, max: 9,
}), 'genetic.pushNodeRandom');

console.log(genetic.nodes);
