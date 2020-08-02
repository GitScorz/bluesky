const App = require('./app').Application;

const InfoController = require('./controllers/info');
const MdtController = require('./controllers/mdt');

const app = new App([new InfoController(), new MdtController()], [], 1337);
app.listen();
