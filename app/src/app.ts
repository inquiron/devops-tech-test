import koaBody from "koa-body";
import { Application } from "./lib/app";
import { helloWorldRouter, healthRouter } from "./routes";
import { configuration } from "./lib/config";

export const application = new Application();

application.keys = configuration.app.keys;

application.use(koaBody());

application.router = healthRouter;
application.router = helloWorldRouter(configuration);
