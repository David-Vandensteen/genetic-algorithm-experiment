import { JsonDB } from 'node-json-db';
import { Config } from 'node-json-db/dist/lib/JsonDBConfig';
import autoincr from 'autoincr';

const id = autoincr();
const db = new JsonDB(new Config('db', false, false, '/'));

export default class Operation {
  constructor() {
    this.operationsQ = [];
  }

  static create(operation, params) {
    const op = {
      operation,
      // id: `${Math.floor(Math.random() * 1000)}${uniqid()}`,
      id: id.next(),
    };
    if (params) { op.params = params; }
    return op;
  }

  static getHistory() {
    let operationsHistory = false;
    try {
      operationsHistory = db.getData('/operations');
    } catch (error) {
      return false;
    }
    return operationsHistory;
  }

  add(opArray) {
    this.operationsQ = this.operationsQ.concat(opArray);
    return this;
  }

  print(data) {
    const op = Operation.create('print', [data]);
    this.operationsQ.push(op);
    return this;
  }

  wait(frame) {
    const op = Operation.create('wait', [frame]);
    this.operationsQ.push(op);
    return this;
  }

  emuSpeedMode(speed) {
    const op = Operation.create('emu.speedmode', [speed]);
    this.operationsQ.push(op);
    return this;
  }

  emuLoadRom(file) {
    const op = Operation.create('emu.loadrom', [file]);
    this.operationsQ.push(op);
    return this;
  }

  joypadWrite(idPad, options) {
    const op = Operation.create('joypad.write', [idPad, options]);
    this.operationsQ.push(op);
    return this;
  }

  emuPowerOn() {
    const op = Operation.create('emu.poweron');
    this.operationsQ.push(op);
    return this;
  }

  emuFrameAdvance() {
    const op = Operation.create('emu.frameadvance');
    this.operationsQ.push(op);
    return this;
  }

  memoryReadByte(addr) {
    const op = Operation.create('memory.readbyte', [addr]);
    this.operationsQ.push(op);
    return this;
  }

  romReadByte(addr) {
    const op = Operation.create('rom.readbyte', [addr]);
    this.operationsQ.push(op);
    return this;
  }

  commit() {
    const operations = this.operationsQ;
    this.operationsQ = [];
    let operationsHistory = [];
    try {
      operationsHistory = db.getData('/operations');
    } catch (error) {
      console.error(error);
    }
    db.push('/operations', operationsHistory.concat(operations));
    return operations;
  }
}
