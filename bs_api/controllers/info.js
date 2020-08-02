const express = require('express');

class InfoController {
	rootPath = '/info';
	router = express.Router();

	constructor() {
		this.initializeRoutes();
	}

	initializeRoutes = () => {
		this.router.get(`${this.rootPath}/online`, this.onlineList);
		this.router.get(`${this.rootPath}/players`, this.playerList);
		this.router.get(`${this.rootPath}/characters`, this.charList);
		this.router.post(`${this.rootPath}/duty`, this.dutyList);
	}

	onlineList = async (req, res) => {
		setImmediate(() => {
            let fetch = global.exports['bs_base'].FetchComponent('Fetch');
            let players = fetch.All(fetch)

			res.setHeader('content-type', 'application/json');
			res.status(200).send(players.map(player => {
				let char = player.GetData(player, 'Character');
				return (char != null ? { SID: player.GetData(player, 'SID'), noCharacter: false, ...char.GetData(char) } : { noCharacter: true, ...player.GetData(player)} );
			}));
		});
	};

	playerList = async (req, res) => {
		setImmediate(() => {
            let fetch = global.exports['bs_base'].FetchComponent('Fetch');
			let players = Array();
			fetch.All(fetch).map(player => {
				players.push(player.GetData(player));
			});
			res.setHeader('content-type', 'application/json');
			res.status(200).send(players);
		});
	};

	charList = async (req, res) => {
		setImmediate(() => {
            let fetch = global.exports['bs_base'].FetchComponent('Fetch');
            let config = global.exports['bs_base'].FetchComponent('Config');
			let players = fetch.All(fetch)
			let chars = Array();
			Object.keys(players).map((key) => {
				let player = players[key];
				let char = player.GetData(player, 'Character');
				if (char != null) {
					let cData = char.GetData(char);
					chars.push({
						...cData,
						_id: cData.ID,
						Server: config.Server.ID
					});
				}
			});
			res.setHeader('content-type', 'application/json');
			res.status(200).send(chars);
		});
	};

	dutyList = async (req, res) => {
		let { job } = req.body;

		if (job != null && job != '') {
			setImmediate(() => {
				let fetch = global.exports['bs_base'].FetchComponent('Fetch');
				let players = fetch.All(fetch);
				let chars = Array();
				players.map(player => {
					let char = player.GetData(player, 'Character');
					if (char != null) {
						let cData = char.GetData(char);
						if (cData.Job.job === job && cData.JobDuty) {
							chars.push(cData);
						}
					}
				})
				res.setHeader('content-type', 'application/json');
				res.status(200).send(chars);
			});
		} else {
			res.status(404).send('No Job Specified');
		}
	};
}

module.exports = InfoController;