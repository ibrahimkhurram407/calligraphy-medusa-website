import { defineMiddlewares } from "@medusajs/framework/http"
import type {
  MedusaRequest,
  MedusaResponse,
  MedusaNextFunction,
} from "@medusajs/framework/http";

async function logger(
  req: MedusaRequest,
  res: MedusaResponse,
  next: MedusaNextFunction
) {
  console.log("Request received");
  next();
}

export default defineMiddlewares({
  routes: [
    {
      matcher: "/dk",
      middlewares: [logger],
    },
    {
      matcher: "/*",
      middlewares: [logger],
    },
    {
      matcher: "/",
      middlewares: [logger],
    },
    {
      matcher: "/app/login",
      middlewares: [logger],
    },

  ],
})