import express from 'express';
import bodyParser from 'body-parser';
import http from 'http';

class Application {
  app: express.Application;
  httpControllers: any[];
  socketControllers: any[];
  trustedHttpSources = {};
  port: number;
  server: http.Server;

  constructor(httpControllers: any[], socketControllers: any[], port: number) {
    this.app = express();
    this.app.set('trust proxy', true);
    this.httpControllers = httpControllers;
		this.port = port;
		this.initializeMiddlewares();
		this.server = http.createServer(this.app);
  }

  initializeMiddlewares() {
    this.app
      .use(bodyParser.json())
      .use(bodyParser.urlencoded({ extended: true }))
      .use(bodyParser.json());

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