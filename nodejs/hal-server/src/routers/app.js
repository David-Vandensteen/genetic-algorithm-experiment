import { Router } from 'express';
import cors from 'cors';
import { send } from '../lib/tools';
import pkg from '../../package.json';
import Operation from '../lib/operation';
import Macro from '../lib/macro';

const router = new Router();
const operation = new Operation();

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
  .options(cors({ methods: ['OPTIONS', 'GET'] }))
  .get((req, res) => {
    send(req, res, {
      status: 200,
      content:
        operation
          .add(Macro.init('normal'))
          .add(Macro.start())
          .add(Macro.joypadWriteRandomLoop(200))
          .commit(),
    });
  });

export default router;
