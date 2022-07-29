import { Router, Request, Response } from 'express';
import { STATUS_CODES } from '../types/types';
import { GROUPS, PRIORITY, WHITELIST, WHITELIST_ENABLED } from '../config/config';
import { b64enc } from '../utils/utils';

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

  startup(req: Request, res: Response) {
		setImmediate(() => {
      const logger = global.exports['bs_base'].FetchComponent('Logger');
      
      const apiToken = global.exports['bs_base'].FetchComponent('Convar').API_TOKEN.value;
      const apiTokenEnc = b64enc(apiToken);
      
      logger.Info(logger, 'API', 'Admin starting up...', { console: true });

      res.setHeader('Content-Type', 'application/json');
      res.setHeader('Authorization', `Basic ${apiTokenEnc}`);
      
      res.status(STATUS_CODES.OK).send({
        id: 1,
        name: 'Blue Sky',
        region: 'EU',
        access: WHITELIST_ENABLED,
        game: {
          id: 1,
          name: 'Blue Sky',
          short: 'bs',
          groups: {
            staff: GROUPS,
            whitelist: WHITELIST,
            priority: PRIORITY,
          },
          counts: {
            staff: Object.keys(GROUPS).length,
            whitelist: WHITELIST.length,
            priority: PRIORITY.length,
          }
        }
      });
		});
	};
}

export default AdminController;