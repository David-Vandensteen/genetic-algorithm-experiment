module.exports = function (api) {
  api.cache(true);

  const presets = [ require('@babel/preset-env') ];

  return { presets };
}