const fs = require('fs');
const debug = require('debug')('Writer');

class Writer {
  constructor(file) {
    this.file = file;
  }

  push(content) {
    fs.appendFileSync(this.file, `${content}\n`, (err) => {
      debug(err);
    });
    return this;
  }

  lf() {
    fs.appendFileSync(this.file, '\n', (err) => {
      debug(err);
    });
    return this;
  }

  unlink() {
    if (fs.existsSync(this.file)) {
      fs.unlink(this.file, (err) => {
        debug(err);
      });
    }
  }
}

module.exports = Writer;
