const debug = require('debug')('HalServer');
const FceuxScript = require('./class/FceuxScript.js');
const SpaceHarrier = require('./plugins/SpaceHarrier.js');

class HalServer {
  static generateClientScript() {
    debug('Generate script start');
    FceuxScript.emu.poweron()
      .speedmode('normal')
      .frameadvance();

    FceuxScript.joypad.write(1, { start: true, B: false, A: true });

    SpaceHarrier.start();
    SpaceHarrier.isDead();
    debug('Generate script stop');
    return this;
  }
}

HalServer.generateClientScript();
