import Operation from './operation';

export default class Macro {
  static init(speed) {
    let s = 'normal';
    if (speed) s = speed;
    return new Operation()
      .emuSpeedMode(s)
      .commit();
  }

  static start() {
    return new Operation()
      .wait(200)
      .joypadWrite('1', { start: true })
      .emuFrameAdvance()
      .wait(100)
      .joypadWrite('1', { start: true })
      .emuFrameAdvance()
      .wait(110)
      .commit();
  }

  static joypadWriteRandomLoop(opMax) {
    const ops = [];
    for (let i = 0; i < opMax; i += 1) {
      ops.push(Macro.joypadWriteRandom());
      ops.push(new Operation().emuFrameAdvance().commit());
    }
    return ops.flat();
  }

  static joypadWriteRandom() {
    return new Operation()
      .joypadWrite('1', {
        B: Math.random() < 0.5,
        A: Math.random() < 0.5,
        right: Math.random() < 0.5,
        left: Math.random() < 0.5,
        down: Math.random() < 0.5,
        up: Math.random() < 0.5,
      })
      .commit();
  }
}
