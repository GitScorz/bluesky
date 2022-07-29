import { Router, Request, Response } from 'express';

class InfoController {
  rootPath: string;
  router: Router;

  constructor() {
    this.rootPath = '/info';
    this.router = Router();
    this.initializeRoutes();
  }

  initializeRoutes() {
    this.router.get(`${this.rootPath}/online`, this.onlineList);
		this.router.get(`${this.rootPath}/players`, this.playerList);
		this.router.get(`${this.rootPath}/characters`, this.charList);
		this.router.post(`${this.rootPath}/duty`, this.dutyList);
  }

  onlineList(req: Request, res: Response) {
    setImmediate(() => {
      const fetch = global.exports['bs_base'].FetchComponent('Fetch');
      const players = fetch.All(fetch);

      res.setHeader('Content-Type', 'application/json');
      res.status(STATUS_CODES.OK).send(players.map((player) => {
        const char = fetch.GetData(player, 'Character');

        return (
          char != null ? { 
            SID: player.GetData(player, 'SID'),
            noCharacter: false, 
            ...char.GetData(char) 
          } : {
            noCharacter: true, 
            ...player.GetData(player)
          }
        )
      }));
    });
  }

  playerList(req: Request, res: Response) {
    setImmediate(() => {
			const fetch = global.exports['bs_base'].FetchComponent('Fetch');
			let players = Array();

			fetch.All(fetch).map((player) => {
				players.push(player.GetData(player));
			});

			res.setHeader('Content-Type', 'application/json');
			res.status(STATUS_CODES.OK).send(players);
		});
  }

  charList(req: Request, res: Response) {
    setImmediate(() => {
			const fetch = global.exports['bs_base'].FetchComponent('Fetch');
			const config = global.exports['bs_base'].FetchComponent('Config');
			const players = fetch.All(fetch);

			let chars = Array();

			Object.keys(players).map((key) => {
				const player = players[key];
				const char = player.GetData(player, 'Character');

				if (char != null) {
					const cData = char.GetData(char);
					chars.push({
						...cData,
						_id: cData.ID,
						Server: config.Server.ID
					});
				}
			});

			res.setHeader('Content-Type', 'application/json');
			res.status(STATUS_CODES.OK).send(chars);
		});
  }

  dutyList(req: Request, res: Response) {
    const { job } = req.body;

		if (job != null && job != '') {
			setImmediate(() => {
				const fetch = global.exports['bs_base'].FetchComponent('Fetch');
				const players = fetch.All(fetch);

				let chars = Array();

				players.map((player) => {
					const char = player.GetData(player, 'Character');

					if (char != null) {
						const cData = char.GetData(char);
						if (cData.Job.job === job && cData.JobDuty) {
							chars.push(cData);
						}
					}
				})
				res.setHeader('content-type', 'application/json');
				res.status(STATUS_CODES.OK).send(chars);
			});
		} else {
			res.status(STATUS_CODES.NOT_FOUND).send('No job specified.');
		}
  }
}

export default InfoController;