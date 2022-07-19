const express = require('express');

function _b64enc(str) {
    return Buffer.from(str).toString('base64');
}

class AdminController {
  rootPath = '/admin';
  router = express.Router();

  constructor() {
    this.initializeRoutes();
  }

  initializeRoutes = () => {
		this.router.get(`${this.rootPath}/startup`, this.startup);
		this.router.get(`${this.rootPath}/blacklist`, this.blacklist);
		this.router.get(`${this.rootPath}/ban`, this.ban);
	}

  startup = async (req, res) => {
		setImmediate(() => {
      global.exports['bs_base'].FetchComponent('Logger').Info(null, 'API', 'Admin starting up...', { console: true });
      res.setHeader('content-type', 'application/json');
      res.setHeader('Authorization', 'Basic ' + _b64enc(global.exports['bs_base'].FetchComponent('Convar').API_TOKEN.value));
      
      res.status(200).send({
        id: 1,
        name: 'admin',
        // access: 'test',
        region: 'US',
        game: {
          id: 1,
          name: 'bluesky',
          short: 'bs',
          groups: {
            staff: {
              license: "1bb367543c90827a499233ce85abbc4a9a29ecfc",
              level: 100,
            },
            whitelist: [],
            priority: [],
          },
          counts: {
            staff: 1,
            whitelist: 1,
            priority: 0,
            test: 0,
          }
        }
      });
		});
	};

  blacklist = async (req, res) => {

  }

  ban = async (req, res) => {

  }
}

module.exports = AdminController;