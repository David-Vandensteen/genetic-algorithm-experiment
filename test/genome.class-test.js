/* global Genome */
const fs = require('fs');
const vm = require('vm');
const tap = require('tap');

function include(path) {
  const code = fs.readFileSync(path, 'utf-8');
  vm.runInThisContext(code, path);
}

include('../js/genome.class.js');
let genome = new Genome();


tap.ok(new Genome(), 'new Genome');
tap.ok(new Genome().randomize({ genes: 10, min: 0, max: 9 }), 'new Genome().radomize');
tap.ok(new Genome([0, 2, 4, 6]).compare(new Genome([0, 1, 2, 3])), 'new Genome().compare');
console.log(genome);
console.log(new Genome().randomize({ genes: 10, min: 0, max: 9 }));
console.log(new Genome([0, 1, 2, 3, 4, 5, 6]));
console.log(new Genome([0, 1, 2, 2]).compare(new Genome([0, 1, 2, 3])));
console.log(new Genome([0, 2, 4, 6]).compare(new Genome([0, 1, 2, 3])));

const sequencesTest = [
  [0, 1],
  [0, 2],
  [0, 3],
];
console.log('static make genome pre load sequences');
console.log(Genome.make({ sequences: sequencesTest } ));
console.log('static make some genomes random sequences')
console.log(Genome.make({ 
  genomes: 10, genes: 10, sequences: 'random', min: 0, max: 9,
}));


