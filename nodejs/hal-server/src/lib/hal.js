import Operation from './operation';
import Macro from './macro';

export default class Hal {
  static start() {
    return new Operation()
      .add(Macro.init('normal'))
      .add(Macro.start())
      .add(Macro.joypadWriteRandom({
        a: 0.5,
        b: 0.5,
        right: 0.5,
        left: 0.5,
        down: 0.5,
        up: 0.5,
      }, {
        autoFrame: true,
        quantity: 2,
      }))
      .commit();
  }
}
