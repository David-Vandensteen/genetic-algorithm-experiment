import Hal from './lib/hal';
import Operation from './lib/operation';
import Macro from './lib/macro';

export default class Gradius extends Hal {
  operationsInit() {
    this.spinnies.remove('player');
    this.spinnies.add('player', { text: 'player is alive' });
    this.log.info('playing macro game start');
    this.startGame = true;
    if (Operation.getHistory()) {
      this.spinnies.update('mode', { text: 'mode : replay' });
      // this.log.info(Operation.getHistory());
      return Operation.getHistory();
    }
    return new Operation()
      .emuPowerOn()
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
    if (isDead) {
      this.log.info('PLAYER IS DEAD - RESET GAME');
      this.replay = true;
      this.spinnies.fail('player', { text: 'player is death' });
    }
    return isDead;
  }
}
