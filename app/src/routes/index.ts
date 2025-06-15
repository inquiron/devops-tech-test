import Router from "koa-router";

const helloWorldRouter = (config: any) => {
  const router = new Router();

  router.get("/", async (ctx) => {
    ctx.body = "Hello, World!";
  });

  return router;
};

const healthRouter = new Router();
healthRouter.get("/healthz", async (ctx) => {
  ctx.status = 200;
  ctx.body = "OK";
});

export { helloWorldRouter, healthRouter };
