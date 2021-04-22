import { Router } from 'express';
import cors from 'cors';
import { send } from '../lib/tools';
import pkg from '../../package.json';
import Operation from '../lib/operation';
import Macro from '../lib/macro';

const router = new Router();
const operation = new Operation();

const { log } = console;

router
  .route('/')
  .options(cors({ methods: ['OPTIONS', 'GET'] }))
  .get((req, res) => {
    send(req, res, {
      status: 200,
      content: {
        name: pkg.name,
        description: pkg.description,
        version: pkg.version,
        author: pkg.author,
        license: pkg.license,
      },
    });
  });

router
  .route('/operations')
  .options(cors({ methods: ['OPTIONS', 'GET', 'POST'] }))
  .get((req, res) => {
    send(req, res, {
      status: 200,
      content:
        operation
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
          .commit(),
    });
  })
  .post((req, res) => {
    log(req.query.lastOp);
    res.send(200);
  });

export default router;
