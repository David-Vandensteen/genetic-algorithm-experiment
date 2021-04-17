export default class Tools {
  static getData(data, key, fail) {
    try {
      let subdata = data;
      const keys = key.split('.');
      keys.forEach((k) => {
        subdata = subdata[k];
      });
      return typeof subdata !== 'undefined' ? subdata : fail;
    } catch (err) {
      return fail;
    }
  }

  static checkAccepts(accepts) {
    return (req, res, next) => {
      const accept = req.accepts(accepts);
      if (accept) {
        req.accept = accept;
        next();
      } else {
        const err = new Error('Not acceptable');
        err.status = 406;
        next(err);
      }
    };
  }

  static getError(err) {
    function convertErrorToJson(error) {
      const json = {};

      Object.getOwnPropertyNames(error).forEach((key) => {
        json[key] = err[key];
      });

      return json;
    }

    let error = err;
    if (error instanceof Error) {
      error = convertErrorToJson(err);
    }

    return error;
  }

  static send(req, res, content) {
    let response = content;
    if (!(response instanceof Error) && !response.status) {
      response = new Error('Internal server error');
      response.status = 500;
    }

    if (response instanceof Error) {
      const status = response.status || 500;
      const err = Tools.getError(response);
      // delete err.stack;
      res.status(status).send(err);
    } else {
      if (response.type) { res.set('Content-Type', response.type); }
      res.status(response.status).send(response.content);
    }
  }

  static errorHandler(err, req, res, next) {
    if (res.headersSent) next(err);
    Tools.send(req, res, err);
  }

  static noRouteHandler(req, res) {
    const err = new Error('Not found');
    err.status = 404;
    Tools.send(req, res, err);
  }
}

export const {
  checkAccepts,
  errorHandler,
  getData,
  noRouteHandler,
  send,
} = Tools;
