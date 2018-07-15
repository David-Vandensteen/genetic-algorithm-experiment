class Genetic { // eslint-disable-line no-unused-vars
  constructor() {
    this.nodes = [];
  }

  pushNode(genome = [0, 0, 0, 0]) {
    const node = {};
    node.genome = genome.slice();
    node.selected = false;
    node.score = 0;
    this.nodes.push(node);
    return this;
  }

  pushNodesRandomGenes(params) {
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

  fitness(genomeExpected) {

  }
}
