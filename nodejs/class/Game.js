const debug = require('debug')('Game');
const config = require('../config.js');
const FceuxScript = require('./FceuxScript.js');
const Writer = require('../class/Writer.js');

class Game {
  constructor() {
    this.writer = new Writer(config.script.filePath);
    this.config = {
      title: '',
      head: [],
      fileResult: '',
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

  gameStart() { return this; }

  isDead() { return this; }

  updateHud() {
    this.writer.lf();
    this.writer.push('function updateHud()');
    this.writer.push('  gui.text(170, 10, "time " .. game.frame)');
    this.writer.push('end');
    return this;
  }

  main() {
    this.writer.lf();
    this.writer.push('function main()');
    this.writer.push('  while true do');
    this.writer.push('    gameStart()');
    this.writer.push('    while not isDead() do');
    this.writer.push('      updateHud()');
    this.writer.push('      nextFrame()');
    this.writer.push('    end');
    this.writer.push(`    saveResult("${this.config.fileResult})"`);
    this.writer.push('  end');
    this.writer.push('end');
    this.writer.lf();
    this.writer.push('main()');
    return this;
  }

  script() {
    debug('Generate script start');
    FceuxScript.emu.poweron().speedmode('normal').frameadvance();
    this.gameStart().isDead().updateHud().main();
    debug('Generate script stop');
    return this;
  }
}

module.exports = Game;
