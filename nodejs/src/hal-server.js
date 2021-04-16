// import pSeries from 'p-series';
// import pAll from 'p-all';
import pLimit from 'p-limit';
import Operation from './lib/operation';

// const { log } = console;

const operation = new Operation('./operations.json');

/*
operation.initMacro('normal')
  .print('hello 1')
  .commit()
  .then(
    () => operation
      .print('hello 2')
      .commit(),
  )
  .catch(error);
*/
const limit = pLimit(1);
const controls = [];

for (let i = 0; i < 5000; i += 1) {
  controls.push(
    limit(() => operation.joypadWrite('1', {
      B: Math.random() < 0.5,
      A: Math.random() < 0.5,
      right: Math.random() < 0.5,
      left: Math.random() < 0.5,
      down: Math.random() < 0.5,
      up: Math.random() < 0.5,
    })
      .emuFrameAdvance()
      .commit()),
  );
}

Promise.all([
  limit(() => operation.initMacro().startMacro().commit()),
  ...controls,
]);

/*
pAll([
  () => {
    operation.print('hello1').commit();
  },
  () => {
    operation.print('hello2').commit();
  },
], { concurrency: 1 });
*/
/*
pSeries([
  () => {
    operation.initMacro('normal')
      .startMacro()
      .commit();
  },
  () => {
    operation.print('hello 2')
      .commit();
  },
])
  .then(() => { log('complete'); });
*/
/*
const controls = [];
for (let i = 0; i < 200; i += 1) {
  controls.push(
    () => {
      operation.joypadWrite('1', {
        B: Math.random() < 0.5,
        A: Math.random() < 0.5,
        right: Math.random() < 0.5,
        left: Math.random() < 0.5,
        down: Math.random() < 0.5,
        up: Math.random() < 0.5,
      })
        .emuFrameAdvance()
        .commit()
        .catch(error);
    },
  );
}
*/

/*
console.log(Math.random() < 0.1); //10% probability of getting true
console.log(Math.random() < 0.4); //40% probability of getting true
console.log(Math.random() < 0.5); //50% probability of getting true
console.log(Math.random() < 0.8); //80% probability of getting true
console.log(Math.random() < 0.9); //90% probability of getting true
*/

/*
operation.wait(100)
  .emuPowerOn()
  .emuSpeedMode('normal')
  .print('hello from node')
  .joypadWrite('1', { start: true })
  .commit()
  .catch(error);
*/
