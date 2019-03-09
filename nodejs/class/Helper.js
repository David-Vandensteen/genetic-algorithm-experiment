class Helper {
  static convertObj2Table(object) {
    // convert a js object to a LUA table string
    // ex:
    // { start: true, B: false }    // input js object format
    // { start = true, B = false }  // output LUA table format

    return JSON.stringify(object)
      .replace(/"/g, '')
      .replace(/:/g, ' = ')
      .replace(/,/g, ', ')
      .replace(/{/g, '{ ')
      .replace(/}/g, ' }');
  }
}

module.exports = Helper;
