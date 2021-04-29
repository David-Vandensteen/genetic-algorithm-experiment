import Hal from './lib/hal';
import Operation from './lib/operation';
import Macro from './lib/macro';

export default class Gradius extends Hal {
  operationsInit() {
    this.log.info('playing macro game start');
    this.startGame = true;
    const operation = new Operation();
    operation
      .add(Macro.init('normal'))
      .add(Macro.start())
      .emuFrameAdvance();
    return operation.commit();
  }

  // eslint-disable-next-line class-methods-use-this
  operationsUpdate() {
    // this.log.info('client ask for new operations ...');
    return new Operation()
      .add(
        Macro.joypadWriteRandom({
          a: 0.5,
          b: 0.5,
          right: 0.5,
          left: 0.5,
          down: 0.5,
          up: 0.5,
        }),
      )
      .memoryReadByte(0x004c)
      .emuFrameAdvance()
      .commit();
  }

  // eslint-disable-next-line class-methods-use-this
  dead(data) {
    const isDead = (data > 0 && data < 255);
    if (isDead) this.log.info('PLAYER IS DEAD - RESET GAME');
    return isDead;
  }
}
