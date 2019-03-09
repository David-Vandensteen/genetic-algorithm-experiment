const FceuxScript = require('./class/FceuxScript.js');
const SpaceHarrier = require('./plugins/SpaceHarrier.js');

FceuxScript.emu.poweron()
  .speedmode()
  .frameadvance();

FceuxScript.joypad.write();

SpaceHarrier.FceuxScriptGameStartMacro();
