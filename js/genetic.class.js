class Genetic { // eslint-disable-line no-unused-vars
  constructor() {
    this.nodes = [];
  }

  pushNode(genomeSequence = [0, 0, 0, 0]) {
    const node = {};
    node.genome = genomeSequence.slice();
    node.selected = false;
    node.score = 0;
    this.nodes.push(node);
    return this;
  }

  pushNodeRandomGene(params) {
    let genome = [];
    let i = 0;
    let j = 0;
    for (j = 0; j < params.nodeMax; j += 1) {
      for (i = 0; i < params.geneMax; i += 1) {
        genome.push(Math.floor((Math.random() * params.max) + params.min));
      }
      this.pushNode(genome);
      genome = [];
    }
    return this;
  }

  static compareGenome(genomeA, genomeB) {
    const genesMatch = [];
    let geneIndex = 0;     
    genomeA.forEach((gene) => {
      if (genomeB[geneIndex] === gene) { genesMatch[geneIndex] = true; }
      else { genesMatch[geneIndex] = false; }
      geneIndex += 1;
    });
    return genesMatch;
  }

  static getMatchEvaluationRaw(genesMatch) {
    const total = 0;
    const trueMax = 0;
    const count = 0;
    const rt = { true: 0, false: 0, total: 0 };
    genesMatch.forEach((geneMatch) => {
      // nbr true * 100 / total (%)
      if (geneMatch === true) { trueMax += 1; }
      count += 1;
    });
    rt.true = trueMax;
    rt.total = count;
    rt.false = count - trueMax;
    return rt;
  }
}
