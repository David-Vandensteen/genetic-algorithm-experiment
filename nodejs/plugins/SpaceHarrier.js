const config = require('../config.js');
const Writer = require('../class/Writer.js');
const Game = require('../class/Game.js');

const writer = new Writer(config.script.filePath);

class SpaceHarrier extends Game {
  constructor() {
    super();
    this.config.title = 'Space Harrier';
    this.config.head = [
      0x4E, 0x45, 0x53, 0x1A, 0x08, 0x00, 0x10, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    ];
  }

  start() {
    writer.lf();
    writer.push('-- Macro to start the Game --------------------');
    writer.push('wait(100)');
    writer.push('joypad.write(1, { start = true })');
    writer.push('emu.frameadvance()');
    writer.push('joypad.write(1, { start = true })');
    writer.push('emu.frameadvance()');
    writer.push('wait(100)');
    writer.push('joypad.write(1, { start = true })');
    writer.push('emu.frameadvance()');
    writer.push('joypad.write(1, { start = true })');
    writer.push('emu.frameadvance()');
    writer.push('-----------------------------------------');
    writer.lf();
    return this;
  }

  isDead() {
    writer.lf();
    writer.push('function isDead()');
    writer.push('  local rt = false');
    writer.push('   while (memory.readbyte(0x00B1) == 0x01) do');
    writer.push('     rt = true');
    writer.push('     emu.frameadvance()');
    writer.push('     while true do emu.frameadvance() end');
    writer.push('   end');
    writer.push('  return rt');
    writer.push('end');
    writer.lf();
    return this;
  }

  main() {
    writer.lf();
    writer.push('function main()');
    writer.push('  while true do');

    return this;
  }
}

module.exports = new SpaceHarrier();
