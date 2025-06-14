import Ajv from "ajv";
import type { CurrentOptions } from "ajv/dist/core";
import formats from "ajv-formats";
import { Middleware } from "koa";

interface SchemaDefinition {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  [key: string]: any;
}

interface Schema {
  headers?: SchemaDefinition;
  body?: SchemaDefinition;
  query?: SchemaDefinition;
  files?: SchemaDefinition;
  path?: SchemaDefinition;
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  [key: string]: any;
}

interface Config {
  schema: Schema;
  opts?: CurrentOptions;
  expose?: boolean;
}

export function schemaMiddlewareFactory(
  config: Config,
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
): Middleware<{ data: { [key: string]: any } }> {
  const { opts = {}, expose = false, schema } = config;
  const { headers, body, query, path, files } = schema;
  const schemaDefinition = {
    type: "object",
    properties: {
      headers: headers || {},
      body: body || {},
      query: query || {},
      path: path || {},
      files: files || {},
    },
    required: ["headers", "body", "query", "path", "files"],
  };
  const ajv = new Ajv({
    removeAdditional: true,
    useDefaults: true,
    coerceTypes: true,
    allErrors: true,
    ...opts,
  });
  formats(ajv);

  const validate = ajv.compile(schemaDefinition);

  return async function schemaMiddleware(ctx, next) {
    const path = ctx.params || {};
    const query = ctx.query || {};
    const headers = ctx.headers || {};
    const body = ctx.request.body || {};
    const files = ctx.request.files || {};
    const data = { headers, path, query, body, files };

    if (!validate(data)) {
      ctx.throw(400, "Bad Request", ...(expose ? [validate.errors!] : []));
    }

    ctx.state.data = data;
    return next();
  };
}
