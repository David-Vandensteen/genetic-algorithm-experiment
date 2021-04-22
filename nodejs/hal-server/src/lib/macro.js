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
      .wait(200)
      .joypadWrite('1', { start: true })
      .emuFrameAdvance()
      .wait(100)
      .joypadWrite('1', { start: true })
      .emuFrameAdvance()
      .wait(110)
      .commit();
  }

  static joypadWriteRandom(probabilities, options) {
    const ops = [];
    let optionsSanity = { quantity: 1, autoFrame: true };
    if (options) optionsSanity = options;
    for (let i = 0; i < optionsSanity.quantity; i += 1) {
      ops.push(
        new Operation()
          .joypadWrite('1', {
            B: Math.random() < probabilities.b,
            A: Math.random() < probabilities.a,
            right: Math.random() < probabilities.right,
            left: Math.random() < probabilities.left,
            down: Math.random() < probabilities.down,
            up: Math.random() < probabilities.up,
          })
          .commit(),
      );
      if (optionsSanity.autoFrame) {
        ops.push(new Operation().emuFrameAdvance().commit());
      }
    }
    return ops.flat();
  }
}
