import fs from 'fs';
import pathExists from 'path-exists';
import pWaitFor from 'p-wait-for';

const fsP = fs.promises;
const { log } = console;

fsP.notExists = (path) => new Promise(
  (resolve, reject) => ((fs.existsSync(path)) ? reject(new Error(`${path} exist`)) : resolve()),
);

function pathNotExists(path) {
  return pathExists(path)
    .then((exist) => !exist);
}

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
      .then(() => {
        this.operationsQ = [];
        return pWaitFor(() => pathNotExists(this.file))
          .then(() => { Promise.resolve(); })
          .catch(() => { Promise.reject(); });
      });
  }
}
