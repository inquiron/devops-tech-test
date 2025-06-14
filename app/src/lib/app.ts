import { Server } from "http";
import Koa from "koa";
import logger from "koa-pino-logger";

import { Router } from "./router";

export class Application extends Koa {
  private server?: Server;

  constructor(options?: {
    env?: string | undefined;
    keys?: string[] | undefined;
    proxy?: boolean | undefined;
    subdomainOffset?: number | undefined;
    proxyIpHeader?: string | undefined;
    maxIpsCount?: number | undefined;
    asyncLocalStorage?: boolean | undefined;
  }) {
    super(options);

    this.silent = true;
    this.proxy = true;
    this.on("error", console.error);
    this.use(logger());
  }

  public start(port: number) {
    this.server = this.listen(port);
  }

  public stop() {
    this.server?.close();
  }

  public set router(router: Router) {
    this.use(router.attach());
  }
}
