import { application } from "./app";
import { configuration } from "./lib/config";

try {
  application.start(configuration.app.port);
} catch (error) {
  console.error(error);
  application.stop();
}
