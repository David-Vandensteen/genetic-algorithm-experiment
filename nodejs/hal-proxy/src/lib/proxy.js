const { log } = console;

const response = [
  {
    operation: 'print',
    params: [
      'hello from hal-proxy',
    ],
  },
];

export default class Proxy {
  constructor() {
    log(JSON.stringify(response));
  }
}
