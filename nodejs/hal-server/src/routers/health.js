import { Router } from 'express';
import cors from 'cors';

const router = new Router();

router
  .route('/info')
  .options(cors({ methods: ['OPTIONS', 'GET'] }))
  .get((req, res) => {
    res.sendStatus(200);
  });

export default router;
