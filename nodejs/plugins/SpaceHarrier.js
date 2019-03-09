const config = require('../config.js');
const Writer = require('../class/Writer.js');

const writer = new Writer(config.script.filePath);

class SpaceHarrier {
  constructor() {
    this.config = {
      availableControl: [
        'none',
        'right',
        'left',
        'up',
        'down',
        'ul',
        'ur',
        'dl',
        'dr',
      ],
    };
  }

  getConfig() {
    return this;
  }

  FceuxScriptGameStartMacro() {
    writer.push('wait(100)');
    writer.push('joypad.write(1, {start = true})');
    writer.push('emu.frameadvance()');
    writer.push('joypad.write(1, {start = true})');
    writer.push('emu.frameadvance()');
    writer.push('wait(100)');
    writer.push('joypad.write(1, {start = true})');
    writer.push('emu.frameadvance()');
    writer.push('joypad.write(1, {start = true})');
    writer.push('emu.frameadvance()');
    return this;
  }
}

module.exports = new SpaceHarrier();
