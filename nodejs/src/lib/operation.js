import fs from 'fs';

const fsP = fs.promises;
const { log } = console;

export default class Operation {
  constructor(file, fileHistory) {
    this.file = file;
    this.fileHistory = fileHistory;
    this.operationsQ = [];
  }

  initMacro(speed) {
    return this.emuSpeedMode(speed)
      .emuPowerOn();
  }

  startMacro() {
    return this.wait(100)
      .joypadWrite('1', { start: true })
      .emuFrameAdvance()
      .joypadWrite('1', { start: true })
      .emuFrameAdvance();
  }

  print(data) {
    this.operationsQ.push({
      operation: 'print',
      params: [
        data,
      ],
    });
    log(this.operationsQ);
    return this;
  }

  wait(frame) {
    this.operationsQ.push({
      operation: 'wait',
      params: [
        frame,
      ],
    });
    log(this.operationsQ);
    return this;
  }

  emuSpeedMode(speed) {
    this.operationsQ.push({
      operation: 'emu.speedmode',
      params: [
        speed,
      ],
    });
    log(this.operationsQ);
    return this;
  }

  joypadWrite(id, options) {
    this.operationsQ.push({
      operation: 'joypad.write',
      params: [
        id,
        options,
      ],
    });
    log(this.operationsQ);
    return this;
  }

  emuPowerOn() {
    this.operationsQ.push({
      operation: 'emu.poweron',
    });
    log(this.operationsQ);
    return this;
  }

  emuFrameAdvance() {
    this.operationsQ.push({
      operation: 'emu.frameadvance',
    });
    log(this.operationsQ);
    return this;
  }

  commit() {
    return fsP.writeFile(this.file, JSON.stringify(this.operationsQ))
      .then(() => { this.operationsQ = []; });
  }
}
