import Koa from "koa";
import Router from "koa-router";

export class Application extends Koa {
  public router: Router;

  constructor() {
    super();
    this.router = new Router();
  }

  start(port: number): void {
    this.use(this.router.routes()).use(this.router.allowedMethods());
    this.listen(port, () => {
      console.log(`Server running on port ${port}`);
    });
  }

  stop(): void {
    this.removeAllListeners();
  }
}
