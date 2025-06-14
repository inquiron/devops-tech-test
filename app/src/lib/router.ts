import { default as KoaRouter } from "@koa/router";
import compose from "koa-compose";

export class Router extends KoaRouter {
  attach() {
    return compose([this.allowedMethods(), this.routes()]);
  }
}
