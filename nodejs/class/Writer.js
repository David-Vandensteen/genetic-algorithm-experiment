const fs = require('fs');

class Writer {
  constructor(file) {
    this.file = file;
  }

  push(content) {
    fs.appendFileSync(this.file, `${content}\n`, (err) => {
      console.error(err);
    });
    return this;
  }
}

module.exports = Writer;
