/* global Genome */
const fs = require('fs');
const vm = require('vm');
const tap = require('tap');

function include(path) {
  const code = fs.readFileSync(path, 'utf-8');
  vm.runInThisContext(code, path);
}

include('../js/genome.class.js');
const genome = new Genome();


tap.ok(new Genome(), 'new Genome');
tap.ok(new Genome().randomize({ genes: 10, min: 0, max: 9 }), 'new Genome & radomize');

console.log(genome);
console.log(new Genome().randomize({ genes: 10, min: 0, max: 9 }));
console.log(new Genome([0, 1, 2, 3, 4, 5, 6]));
