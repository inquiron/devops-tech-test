import { Middleware } from "koa";
import { RESPONSE_FALLBACK } from "../lib/constant";

type State = {
  data: { query: { name: string } };
};

export const helloWorldMiddleware: Middleware<State> = (ctx) => {
  const { name } = ctx.state.data.query;
  ctx.body = `Hello ${name || RESPONSE_FALLBACK}`;
  ctx.status = 200;
};
