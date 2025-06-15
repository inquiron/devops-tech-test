import koaBody from 'koa-body';
import { Application } from './lib/app';
import { helloWorldRouter, healthRouter } from './routes';
import config from 'config';

export const application = new Application();

application.keys = [config.get<string>('secret.key')];
application.use(koaBody());

// Combine routes correctly
import Router from 'koa-router';
const combinedRouter = new Router()
  .use(healthRouter.routes())
  .use(helloWorldRouter(config).routes());

application.use(combinedRouter.routes());
application.use(combinedRouter.allowedMethods());
