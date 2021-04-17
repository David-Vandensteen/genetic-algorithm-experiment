import axios from 'axios';

const { get } = axios;
const { log } = console;

/*
const response = [
  {
    operation: 'print',
    params: [
      'hello from hal-proxy',
    ],
  },
];
*/

export default class Proxy {
  constructor(serverUrl) {
    get(`${serverUrl}/operations`)
      .then((response) => {
        log(JSON.stringify(response.data));
      });
  }
}
