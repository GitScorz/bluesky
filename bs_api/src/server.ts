import Application from "./app";

import AdminController from "./controllers/admin";
import MemberController from "./controllers/member";
import InfoController from "./controllers/info";
import MDTController from "./controllers/mdt";

const app = new Application([
  new AdminController(),
  new MemberController(),
  new InfoController(),
  new MDTController(),
], [], 1337);

app.listen();