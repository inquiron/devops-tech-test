import { application } from "./app";
import config from "config";

try {
  const port = config.get<number>("app.port");
  const secret = config.get<string>("secret.key");

  if (!port || !secret) {
    throw new Error("Missing required environment configuration.");
  }

  application.start(port);
} catch (error) {
  console.error("Failed to start application:", error);
  application.stop();
}
