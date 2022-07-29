import { Router, Request, Response } from 'express';


class AdminController {
  rootPath: string;
  router: Router;

  constructor() {
    this.rootPath = '/admin';
    this.router = Router();
    this.initializeRoutes();
  }

  initializeRoutes() {
		this.router.get(`${this.rootPath}/startup`, this.startup);
	}

  async startup(req: Request, res: Response) {
		setImmediate(() => {
      const logger = global.exports['bs_base'].FetchComponent('Logger');
      
      const apiToken = global.exports['bs_base'].FetchComponent('Convar').API_TOKEN.value;
      const apiTokenEnc = this._b64enc(apiToken);
      
      logger.Info(logger, 'API', 'Admin starting up...', { console: true });

      res.setHeader('Content-Type', 'application/json');
      res.setHeader('Authorization', `Basic ${apiTokenEnc}`);
      
      res.status(STATUS_CODES.OK).send();

      // res.status(200).send({
      //   id: 1,
      //   name: 'admin',
      //   // access: 'test',
      //   region: 'US',
      //   game: {
      //     id: 1,
      //     name: 'bluesky',
      //     short: 'bs',
      //     groups: {
      //       staff: {
      //         license: "1bb367543c90827a499233ce85abbc4a9a29ecfc",
      //         level: 100,
      //       },
      //       whitelist: [],
      //       priority: [],
      //     },
      //     counts: {
      //       staff: 1,
      //       whitelist: 1,
      //       priority: 0,
      //       test: 0,
      //     }
      //   }
      // });
		});
	};

  _b64enc(key: string) {
    return Buffer.from(key).toString('base64');
  }
}

module.exports = AdminController;