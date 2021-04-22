import arg from 'arg';

const { log } = console;

class Params {
  constructor() {
    this.args = arg({
      '--post': Boolean,
      '--help': Boolean,
      '--lastOp': Number,
      '--alive': String,
      '--download': String,
    });
  }

  process() {
    if (this.args['--help']) Params.help();
    return this.args;
  }

  static help() {
    log('');
    log('hal-proxy', '[options]');
    log('');
    log('     Options:');
    log('');
    log('   --post');
    log('   --download        : Game rom to download');
    log('');
    process.exit(0);
  }
}

export default new Params();
