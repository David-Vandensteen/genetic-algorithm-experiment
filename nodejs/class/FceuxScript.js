const debug = require('debug')('FceuxScript');
const config = require('../config.js');
const Writer = require('./Writer.js');
const Helper = require('./Helper.js');

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

  speedmode(mode) {
    if (mode === 'normal' || mode === 'nothrottle' || mode === 'turbo' || mode === 'maximum') {
      writer.push(`emu.speedmode("${mode}")`);
    } else {
      debug(`ERROR speedmode ${mode} is not supported`);
      process.exit(1);
    }
    return this;
  }
}

class joypad {
  write(player, inputs) {
    writer.push(`joypad.write(${player}, ${Helper.convertObj2Table(inputs)})`);
    return this;
  }
}

class FceuxScript {
  constructor() {
    writer.unlink();
    this.emu = new emu();       // eslint-disable-line
    this.joypad = new joypad(); // eslint-disable-line
    this.implementVar();
    this.implementNextFrame();
    this.implementWait();
    this.implementSaveResult();
  }

  implementVar() {
    writer.push('game = {}');
    writer.push('game.sequence = {}');
    writer.push('game.frame = 0');
    writer.push('game.sequence.id = 0');
    writer.push('game.sequence.genome = {0, 1, 2, 3, 4,0, 1, 2, 3, 4,0, 1, 2, 3, 4,0, 1, 2, 3, 4,0, 1, 2, 3, 4,0, 1, 2, 3, 4,0, 1, 2, 3, 4,0, 1, 2, 3, 4,0, 1, 2, 3, 4,0, 1, 2, 3, 4,0, 1, 2, 3, 4,0, 1, 2, 3, 4,0, 1, 2, 3, 4,0, 1, 2, 3, 4}');
    writer.lf();
    return this;
  }

  implementNextFrame() {
    writer.push('function nextFrame()');
    writer.push('  game.frame = game.frame + 1');
    writer.push('  emu.frameadvance()');
    writer.push('end');
    writer.lf();
    return this;
  }

  implementWait() {
    writer.push('function wait(frameMax)');
    writer.push(' local curF = emu.framecount()');
    writer.push(' while emu.framecount() < curF + frameMax do');
    writer.push('  emu.frameadvance()');
    writer.push(' end');
    writer.push('end');
    writer.lf();
    return this;
  }

  implementSaveResult() {
    writer.lf();
    writer.push('function saveResult(_file)');
    writer.push('  local file = io.open(_file .. "w+")');
    writer.push('  io.close(file)');
    writer.push('  local file = io.open(_file .. "a")');
    writer.push('  io.output(file)');
    writer.push('  io.write("frameMax = ".. game.frame)');
    writer.push('  io.write("\\n")');
    writer.push('  io.close(file)');
    writer.push('end');
    writer.lf();
    return this;
  }


  wait(frameMax) {
    writer.push(`wait(${frameMax})`);
    return this;
  }
}

module.exports = new FceuxScript();
