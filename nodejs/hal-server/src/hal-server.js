import pSeries from 'p-series';
import Operation from './lib/operation';

// const { log } = console;

const operation = new Operation('./operations.json');

const controls = [];
for (let i = 0; i < 100; i += 1) {
  controls.push(
    () => operation.joypadWrite('1', {
      B: Math.random() < 0.5,
      A: Math.random() < 0.5,
      right: Math.random() < 0.5,
      left: Math.random() < 0.5,
      down: Math.random() < 0.5,
      up: Math.random() < 0.5,
    })
      .emuFrameAdvance()
      .commit(),
  );
}

pSeries([
  () => operation.initMacro('normal')
    .startMacro()
    .commit(),

  ...controls,
]);
