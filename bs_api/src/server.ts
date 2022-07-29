import Application from "./app";

import InfoController from "./controllers/info";

const app = new Application([
  new InfoController(),
], [], 1337);

app.listen();