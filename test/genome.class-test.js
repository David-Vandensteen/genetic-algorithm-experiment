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
tap.ok(Genome.make({ // return 10 genomes with 10 random genes between 0 & 9
  genomes: 10, genes: 10, sequences: 'random', min: 0, max: 9,
}), 'Genome.make - test 1');

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

tap.same(Genome.make({ sequences: input }), wanted, 'Genome.make - test 2 (static sequences)');
let genomes = [];
genomes = Genome.make({ sequences: input }).slice(); 

// return 10 genomes with 3 genomes in hard code sequence, padding with 7 random genomes
tap.ok(Genome.make({
  genomes: 10, sequences: input, min: 0, max: 9,
}), 'Genome.make - test 3');


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


class SecretTest {
  constructor(genomesInput) {
    const genomeMax = 6;
    const secret = {};
    secret.sequence = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    secret.checksum = SecretTest.calculateChecksum(secret.sequence);
    if (!genomesInput) {
      genomes = Genome.make({
        genomes: genomeMax, genes: 10, sequences: 'random', min: 0, max: 9,
      }).slice();
    } else {
      genomes = Genome.make({
        genomes: genomeMax, sequences: Genome.extractSequences(genomesInput), min: 0, max: 9,
      }).slice();
    }
    const betters = SecretTest.fitness({ genomes: genomes, targetChecksum: secret.checksum, max: 4 }).slice();
    return SecretTest.crossOverAndMutateBetters(betters);
  }

  static crossOverAndMutateBetters(genomes) {
    const rt = [];
    let index = 0;
    genomes.forEach((genome) => {
      if (index < genomes.length - 1) { 
        rt.push(genome.crossOver(genomes[index + 1]).mutate(0, 9));
      } else {
        rt.push(genome.crossOver(genomes[0]).mutate(0, 9));
      }
      index += 1;
    });
    return rt;
  }

  static calculateChecksum(sequence) {
    let checksum = null;
    sequence.forEach((num) => {
      checksum += num;
    });
    return checksum;
  }

  static fitness(params) {
    // signature : { genomes: , max: , targetChecksum: }

    // console.log('fitness enter params :');
    // console.log(params);

    let rt = [];
    params.genomes.map((genome) => { // calulate checsum
      return Object.assign(genome, { checksum: SecretTest.calculateChecksum(genome.sequence) });
    });
    const sort = params.genomes.sort((a, b) => {
      return a.checksum - b.checksum;
    }).slice();

    // console.log('fitness sort & check sum calculate :');
    // console.log(sort);

    sort.map((s) => { // sort
      if (s.checksum === 0) console.log('CHECKSUM FOUND');
      console.log(s.checksum);
      delete s.checksum;
      return s;
    });
    if (params.max) { // return max betters
      let i = 0;
      sort.forEach((s) => {
        if (i < params.max) { rt.push(s); }
        i += 1;
      });
    } else {
      rt = sort.slice();
    }
    return rt;
  }
}

// console.log(new SecretTest());

let i;
let result = new SecretTest().slice();
for (i = 100000; i > 0; i -= 1) {
  result = new SecretTest(result).slice();
  // console.log(result);
}
