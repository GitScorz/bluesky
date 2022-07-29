const express = require('express');

class MemberController {
  rootPath = '/member';
  router = express.Router();

  constructor() {
    this.initializeRoutes();
  }

  initializeRoutes = () => {
		this.router.get(`${this.rootPath}/sid`, this.getSidData);
		this.router.get(`${this.rootPath}/identifier`, this.getIdentifier);
	}

  getSidData = async (req, res) => {
    console.log("SID " + req.body);

    setImmediate(() => {
      res.status(200).send({
        id: 1,
        name: 'test',
        roles: {}
      });
    });
  }

  getIdentifier = async (req, res) => {
    console.log("Identifier " + JSON.stringify(req.body));

    setImmediate(() => {
      res.status(200).send({
        id: 1,
        name: 'test',
        roles: {},
        banned: 0,
      });
    });
  }
  
}

module.exports = MemberController;