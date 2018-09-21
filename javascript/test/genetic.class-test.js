/* global Genetic */
const fs = require('fs');
const vm = require('vm');
const tap = require('tap');

function include(path) {
  const code = fs.readFileSync(path, 'utf-8');
  vm.runInThisContext(code, path);
}

include('../js/genome.class.js');
include('../js/genetic.class.js');
const genetic = new Genetic();


tap.ok(new Genetic(), 'new Genetic');
tap.ok(new Genetic(new Genome().randomize({ gene: 10, min: 0, max: 0 })));
console.log(genetic.nodes);
