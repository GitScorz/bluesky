import { Router, Request, Response } from 'express';
import { STATUS_CODES } from '../types/types';

class MDTController {
	rootPath: string;
	router: Router;

	constructor() {
    this.rootPath = '/mdt';
    this.router = Router();
		this.initializeRoutes();
	}

	initializeRoutes() {
		this.router.get(`${this.rootPath}/callsign`, this.callsign);
		this.router.post(`${this.rootPath}/panic`, this.panic);
	}

	callsign(req: Request, res: Response) {
		const { charId, callsign } = req.body;
		res.setHeader('Content-Type', 'application/json');

		if (charId != null && callsign != null) {
			setImmediate(() => {
				const fetch = global.exports['bs_base'].FetchComponent('Fetch');
				const player = fetch.CharacterData(fetch, '_id', charId)
				
				if (player != null) {
					const char = player.GetData(player, 'Character')
					char.SetData(char, 'callsign', callsign);

					emitNet('Characters:Client:SetData', char.GetData(char, 'Source'), char.GetData(char))
				}

				res.status(STATUS_CODES.OK).send();
			});
		} else {
			res.status(STATUS_CODES.BAD_REQUEST).send();
		}
	};

	panic(req: Request, res: Response) {
		setImmediate(() => {
			emit('Sounds:Server:Play:Distance', +req.body.source, 15, 'panic', 100);
			res.status(STATUS_CODES.OK).send();
		});
	}
}

export default MDTController;