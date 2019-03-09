class Game {
  constructor() {
    this.config = {
      title: '',
      head: [],
      availableControls: [
        { control: 'none', value: 0 },
        { control: 'right', value: 1 },
        { control: 'left', value: 2 },
        { control: 'up', value: 3 },
        { control: 'down', value: 4 },
        { control: 'ul', value: 5 },
        { control: 'ur', value: 6 },
        { control: 'dl', value: 7 },
        { control: 'dr', value: 8 },
      ],
    };
  }

  getConfig() {
    return this.config;
  }

  start() { return this; }

  isDead() { return this; }

  main() { return this; }
}

module.exports = Game;
