const config = require('../config.js');
const Writer = require('./Writer.js');

const writer = new Writer(config.script.filePath);

class emu {
  frameadvance() {
    writer.push('emu.frameadvance()');
    return this;
  }

  poweron() {
    writer.push('emu.poweron()');
    return this;
  }

  speedmode() { // TODO signature
    writer.push('emu.speedmode');
    return this;
  }
}

class joypad {
  write() { // TODO signature
    writer.push('joypad.write()');
    return this;
  }
}

class FceuxScript {
  constructor() {
    this.emu = new emu();
    this.joypad = new joypad();
    this.implementWait();
  }

  implementWait() {
    writer.push('function wait(frameMax)');
    writer.push(' local curF = emu.framecount()');
    writer.push(' while emu.framecount() < curF + frameMax do');
    writer.push('  emu.frameadvance()');
    writer.push(' end');
    writer.push('end');
    return this;
  }
}

module.exports = new FceuxScript();
