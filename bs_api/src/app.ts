import express from 'express';
import { json, urlencoded } from 'body-parser';
import { Server, createServer} from 'http';

class Application {
  app: express.Application;
  httpControllers = [];
  socketControllers = [];
  trustedHttpSources = {};
  port: number;
  server: Server;

  constructor(httpControllers: any[], socketControllers: any[], port: number) {
    this.app = express();
    this.app.set('trust proxy', true);
    this.httpControllers = httpControllers;
		this.port = port;
		this.initializeMiddlewares();
		this.server = createServer(this.app);
  }

  initializeMiddlewares() {
    this.app
      .use(json())
      .use(urlencoded({ extended: true }))
      .use(express.json());

    this.httpControllers.forEach((controller) => {
      this.app.use('/', controller.router);
    });
  }

  listen() {
    this.server.listen(this.port, () => {
      console.log(`App listening on the port ${this.port}.`);
    });

    return this.server;
  }
}

export default Application;