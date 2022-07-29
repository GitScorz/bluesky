const express = require('express');
const axios = require('axios');
const bodyParser = require('body-parser');
const http = require('http');

class Application {
	httpControllers = [];
	socketControrllers = [];

	trustedHttpSources = {};

	constructor(httpControllers, socketControrllers, port) {
		this.app = express();
		this.app.set('trust proxy', true);
		this.httpControllers = httpControllers;
		this.port = port;
		this.initializeMiddlewares();
		this.server = http.createServer(this.app);
	}

	initializeMiddlewares = () => {
		this.app
			.use(bodyParser.json())
			.use(bodyParser.urlencoded({ extended: true }))
			.use(express.json());

		this.httpControllers.forEach((controller) => {
			this.app.use('/', controller.router);
		});
	}

	listen = () => {
		this.server.listen(this.port, () => {
			console.log(`App listening on the port ${this.port}`);
		});

		return this.server;
	}
}

module.exports = { Application }
