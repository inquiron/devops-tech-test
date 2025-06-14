import { Router } from "@/lib/router";
import { helloWorldMiddleware, schemaMiddlewareFactory } from "@/middleware";
import compose from "koa-compose";

export function helloWorldRouter(config: { secret: { key: string } }) {
  const geolocationRouter = new Router();

  geolocationRouter.get(
    "/hello",
    compose([
      schemaMiddlewareFactory({
        schema: {
          query: {
            type: "object",
            properties: {
              name: { type: "string", minLength: 1 },
            },
          },
        },
      }),
      helloWorldMiddleware,
    ]),
  );

  return geolocationRouter;
}
