import { Router } from 'express';
import cors from 'cors';
import { send } from '../lib/tools';
import Hal from '../lib/hal';
import pkg from '../../package.json';

const router = new Router();
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
      content: Hal.start(),
    });
  })
  .post((req, res) => {
    // log(req.query.lastOp);
    if (req.query.alive === 'false') {
      log('GRADIUS IS DEAD');
    }
    res.send(200);
  });

// TODO : refactoring
router
  .route('/downloads/roms/gradius')
  .options(cors({ methods: ['OPTIONS', 'GET'] }))
  .get((req, res) => {
    // Gradius (USA).zip
    res.sendFile('Gradius (USA).zip', {
      root: 'c:\\temp',
    });
  });

export default router;
