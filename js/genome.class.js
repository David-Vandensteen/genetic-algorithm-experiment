class Genome { // eslint-disable-line no-unused-vars
  constructor(sequence = []) {
    this.sequence = sequence.slice();
  }

  static make(params) {
    const nodes = [];
    if (params.sequences !== 'random') {
      params.sequences.forEach((seq) => {
        nodes.push(new Genome(seq));
      });
    } else {
      let i;
      for (i = 0; i < params.genomes; i += 1 ) {
        nodes.push(new Genome().randomize({ genes: params.genes, min: params.min, max: params.max }));
      }
    }
    return nodes;
  }

  randomize(params) {
    this.sequence = [];
    let i = 0;
    for (i = 0; i < params.genes; i += 1) {
      this.sequence.push(Math.floor((Math.random() * params.max) + params.min))
    }
    return this;
  }

  compare(genome) {
    const result = {};
    result.average = null;
    result.bool = {};
    result.bool.gap = [];

    result.real = {};
    result.real.gap = [];
    let trueMax = 0;
    let total = 0;
    let geneIndex = 0;

    genome.sequence.forEach((gene) => {
      if (this.sequence[geneIndex] === gene) { 
        result.bool.gap.push(true);
        result.real.gap.push(0);
        trueMax += 1;
      } else { 
        result.bool.gap.push(false);
        result.real.gap.push(Math.abs(this.sequence[geneIndex] - gene));
      }
      total += 1;
      geneIndex += 1;
    });
    result.average = (trueMax * 100 / total) / 100;
    return result;
  }
}
