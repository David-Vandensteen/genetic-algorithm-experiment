const Game = require('../class/Game.js');

class SpaceHarrier extends Game {
  constructor() {
    super();
    this.config.title = 'Space Harrier';
    this.config.fileResult = 'c:\\temp\\space-harrier-result.txt';
    this.config.head = [
      0x4E, 0x45, 0x53, 0x1A, 0x08, 0x00, 0x10, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    ];
  }

  gameStart() {
    this.writer.lf();
    this.writer.push('function gameStart()');
    this.writer.push('  emu.poweron()');
    this.writer.push('  game.frame = 0');
    this.writer.push('  wait(100)');
    this.writer.push('  joypad.write(1, { start = true })');
    this.writer.push('  emu.frameadvance()');
    this.writer.push('  joypad.write(1, { start = true })');
    this.writer.push('  emu.frameadvance()');
    this.writer.push('  wait(100)');
    this.writer.push('  joypad.write(1, { start = true })');
    this.writer.push('  emu.frameadvance()');
    this.writer.push('  joypad.write(1, { start = true })');
    this.writer.push('  emu.frameadvance()');
    this.writer.push('end');
    return this;
  }

  isDead() {
    this.writer.lf();
    this.writer.push('function isDead()');
    this.writer.push('  local rt = false');
    this.writer.push('   while (memory.readbyte(0x00B1) == 0x01) do');
    this.writer.push('     rt = true');
    this.writer.push('     emu.frameadvance()');
    this.writer.push('   end');
    this.writer.push('  return rt');
    this.writer.push('end');
    this.writer.lf();
    return this;
  }
}

module.exports = new SpaceHarrier();
