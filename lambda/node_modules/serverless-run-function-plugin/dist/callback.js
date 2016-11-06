'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});
var callback = function callback(serverless) {
  return function (err, result) {
    serverless.cli.log('-----------------');

    if (err) {
      serverless.cli.log('Failed - This Error Was Returned:');
      serverless.cli.log(err.message);
      serverless.cli.log(err.stack);
      return;
    }

    serverless.cli.log('Success! - This Response Was Returned:');
    serverless.cli.log(JSON.stringify(result, null, 4));
  };
};

exports.default = callback;