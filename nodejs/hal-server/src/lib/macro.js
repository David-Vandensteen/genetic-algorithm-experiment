import Operation from './operation';

export default class Macro {
  static init(speed) {
    let s = 'normal';
    if (speed) s = speed;
    return new Operation()
      .emuSpeedMode(s)
      .emuPowerOn()
      .commit();
  }

  static start() {
    return new Operation()
      .add(Macro.getHeader())
      .add(Macro.wait(200))
      .joypadWrite('1', { start: true })
      .emuFrameAdvance()
      .add(Macro.wait(100))
      .joypadWrite('1', { start: true })
      .emuFrameAdvance()
      .add(Macro.wait(110))
      .commit();
  }

  static joypadWriteRandom(probabilities) {
    return new Operation()
      .joypadWrite('1', {
        B: Math.random() < probabilities.b,
        A: Math.random() < probabilities.a,
        right: Math.random() < probabilities.right,
        left: Math.random() < probabilities.left,
        down: Math.random() < probabilities.down,
        up: Math.random() < probabilities.up,
      })
      .commit();
  }

  static getHeader() {
    const operation = new Operation();
    for (let i = 0; i < 16; i += 1) {
      operation
        .romReadByte(i)
        .emuFrameAdvance();
    }
    return operation.commit();
  }

  static wait(frames) {
    const ops = [];
    for (let i = 0; i < frames; i += 1) {
      ops.push(
        new Operation()
          .emuFrameAdvance()
          .commit(),
      );
    }
    return ops.flat();
  }
}
