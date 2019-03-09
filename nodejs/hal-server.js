const SpaceHarrier = require('./plugins/SpaceHarrier.js');

class HalServer {
  static generateClientScript() {
    SpaceHarrier.script();
  }
}

HalServer.generateClientScript();
