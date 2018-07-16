class Genome { // eslint-disable-line no-unused-vars
  constructor(sequence = []) {
    this.sequence = sequence.slice();
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
    return this;
  }
}
