import { Router, Request, Response } from 'express';
import { STATUS_CODES } from '../types/types';
import { b64enc, getGroups, getPlayerSID } from '../utils/utils';

class MemberController {
  rootPath: string;
  router: Router;

  constructor() {
    this.rootPath = '/member';
    this.router = Router();
    this.initializeRoutes();
  }

  initializeRoutes() {
		this.router.get(`${this.rootPath}/roles`, this.getUserRoles);
		this.router.get(`${this.rootPath}/status`, this.getBanStatus);
	}

  async getUserRoles(req: Request, res: Response) {
    const { identifier } = req.body;
    
    setImmediate(() => {
      res.status(STATUS_CODES.OK).send({
        roles: getGroups(identifier),
      });
    });
  }

  async getBanStatus(req: Request, res: Response) {
    const query: any = req.query;
    const source = query.source;
    const identifier = query.identifier;
    // TODO: Check ban status
    
    setImmediate(() => {
      res.status(STATUS_CODES.OK).send({
        name: GetPlayerName(source),
        sid: getPlayerSID(GetPlayerName(source)),
        roles: getGroups(identifier),
        banned: 0,
      });
    });
  }
}

export default MemberController;