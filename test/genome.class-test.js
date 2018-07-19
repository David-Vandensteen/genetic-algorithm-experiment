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
let input;
let wanted;

tap.ok(new Genome(), 'new Genome');
tap.ok(new Genome().randomize({ genes: 10, min: 0, max: 9 }), 'new Genome().radomize');
tap.ok(new Genome([0, 2, 4, 6]).compare(new Genome([0, 1, 2, 3])), 'new Genome().compare');

input = [
  [0, 1],
  [0, 2],
  [0, 3],
];

wanted = [
  { sequence: [0, 1] },
  { sequence: [0, 2] },
  { sequence: [0, 3] },
]

tap.same(Genome.make({ sequences: input }), wanted, 'Genome.make - test 1 (static sequences)');
let genomes = [];
genomes = Genome.make({ sequences: input }).slice(); 

wanted = {
  average: 0.5,
  bool: { gap: [true, false] },
  real: { gap: [0, 1] },
};
tap.same(genomes[0].compare(genomes[1]), wanted, 'genome.compare - test 1');

wanted = {
  average: 0.5,
  bool: { gap: [true, false] },
  real: { gap: [0, 1] },
};
tap.same(genomes[1].compare(genomes[2]), wanted, 'genome.compare - test 2');

wanted = {
  average: 0.5,
  bool: { gap: [true, false] },
  real: { gap: [0, 2] },  
};
tap.same(genomes[0].compare(genomes[2]), wanted, 'genome.compare - test 3');

tap.ok(genomes[0].crossOver(genomes[1]), 'genome.crossover');
tap.ok(genomes[0].mutate(0, 9), 'genome.mutate');

function secretTest() {
  /*
    Try to found the secret sequence example
  */
  function calculateChecksum(sequence) {
    let checksum = null;
    sequence.forEach((num) => {
      checksum += num;
    });
    return checksum;
  }

  function orderByBetter(params) {
    // return the list by better genomes
    // const rt = [];
    params.genomes.forEach((genome) => {
      Object.assign(genome, { gap: genome.checksum - params.targetChecksum });
    });
    console.log(
      genomes.sort((a, b) => {
        return a.checksum - b.checksum;
      })
    );
  }

  const secret = {};
  secret.sequence = [0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
  secret.checksum = calculateChecksum(secret.sequence);
  genomes = Genome.make({
    genomes: 10, genes: 10, sequences: 'random', min: 0, max: 9,
  }).slice();

  genomes.forEach((genome) => {
    Object.assign(genome, { checksum: calculateChecksum(genome.sequence) });
  });

  orderByBetter({ genomes: genomes, targetChecksum: secret.checksum });
  // console.log(genomes);
  // console.log(secret);
}

secretTest();
