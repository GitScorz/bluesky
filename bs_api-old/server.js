const App = require('./app').Application;

const AdminController = require('./controllers/admin');
const MemberController = require('./controllers/member');
const InfoController = require('./controllers/info');
const MdtController = require('./controllers/mdt');

const app = new App([
  new AdminController(),
  new MemberController(),
  new InfoController(),
  new MdtController(),
], [], 1337);

app.listen();
