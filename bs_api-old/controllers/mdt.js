const express = require('express');

class MDTController {
	rootPath = '/mdt';
	router = express.Router();

	constructor() {
		this.initializeRoutes();
	}

	initializeRoutes = () => {
		this.router.get(`${this.rootPath}/callsign`, this.test);
		this.router.post(`${this.rootPath}/panic`, this.panic);
	}

	test = (req, res) => {
		let { charId, callsign } = req.body;
		res.setHeader('content-type', 'application/json');

		if (charId != null && callsign != null) {
			setImmediate(() => {
				let fetch = global.exports['bs_base'].FetchComponent('Fetch');
				let player = fetch.CharacterData(fetch, '_id', charId)
				
				if (player != null) {
					let char = player.GetData(player, 'Character')
					char.SetData(char, 'callsign', callsign);

					TriggerClientEvent('Characters:Client:SetData', char.GetData(char, 'Source'), char.GetData(char))
				}
				res.status(200).send();
			});
		} else {
			res.status(400).send();
		}
	};

	panic = (req, res) => {
		setImmediate(() => {
			console.log(+req.body.source)
			emit('Sounds:Server:Play:Distance', +req.body.source, 15, 'panic', 100);
			res.status(200).send();
		});
	}
}

module.exports = MDTController;