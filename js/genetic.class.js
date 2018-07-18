class Genetic { // eslint-disable-line no-unused-vars
  constructor(genomes = []) {
    this.nodes = [];
    genomes.forEach((genome) => {
      this.nodes.push(genome);
    });
  }
}
