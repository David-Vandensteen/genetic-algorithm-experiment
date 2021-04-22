import express from 'express';
import bodyParser from 'body-parser';
import death from 'death';
import bunyan from 'bunyan';
import expressBunyan from 'express-bunyan-logger';
import cors from 'cors';
import { Server } from 'http';
import config from './config';
import appRouter from './routers/app';
import healthRouter from './routers/health';
import { errorHandler, noRouteHandler } from './lib/tools';

const app = express();
const health = express();
const appServer = Server(app);
const healthServer = Server(health);

const expressLogger = expressBunyan(config.logger.config);
const expressErrorLogger = expressBunyan.errorLogger(config.logger.config);
const log = bunyan.createLogger(config.logger.config);

app.disable('x-powered-by');
app.set('trust proxy', true);

app.use(cors());
app.use(expressLogger);
app.use(bodyParser.urlencoded({ extended: false }));

app.use('/', appRouter);
app.use('/downloads/roms', express.static('static')) // TODO : prod conf
  .options(cors({ methods: ['OPTIONS', 'GET'] }));

app.use(noRouteHandler);
app.use(expressErrorLogger);
app.use(errorHandler);

health.use('/', healthRouter);

appServer.listen(config.app.server.port, config.app.server.host, () => { log.info(`App server listening on ${config.app.server.host}:${config.app.server.port}`); });
healthServer.listen(config.health.server.port, config.health.server.host, () => { log.info(`Health server listening on ${config.health.server.host}:${config.health.server.port}`); });

death(() => {
  appServer.close();
  healthServer.close();
});
