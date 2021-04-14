import fs from 'fs';

const fsP = fs.promises;

export default class Operation {
  static print(data) {
    return fsP.writeFile('./test.json', data);
  }
}
