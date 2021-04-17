const { log } = console;

export default class Operation {
  constructor() {
    this.operationsQ = [];
  }

  add(opArray) {
    this.operationsQ = this.operationsQ.concat(opArray);
    return this;
  }

  print(data) {
    this.operationsQ.push({
      operation: 'print',
      params: [
        data,
      ],
    });
    return this;
  }

  wait(frame) {
    this.operationsQ.push({
      operation: 'wait',
      params: [
        frame,
      ],
    });
    return this;
  }

  emuSpeedMode(speed) {
    this.operationsQ.push({
      operation: 'emu.speedmode',
      params: [
        speed,
      ],
    });
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
    return this;
  }

  emuPowerOn() {
    this.operationsQ.push({
      operation: 'emu.poweron',
    });
    return this;
  }

  emuFrameAdvance() {
    this.operationsQ.push({
      operation: 'emu.frameadvance',
    });
    return this;
  }

  commit() {
    const operations = this.operationsQ;
    this.operationsQ = [];
    return operations;
  }
}
