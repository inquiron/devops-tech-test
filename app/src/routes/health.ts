import { Router } from "@/lib/router";

export const healthRouter = new Router();

healthRouter.get("/healthz", (ctx) => {
  ctx.status = 200;
  ctx.body = { time: new Date().toISOString() };
});
