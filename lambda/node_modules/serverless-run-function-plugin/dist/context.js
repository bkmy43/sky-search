'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _callback = require('./callback');

var _callback2 = _interopRequireDefault(_callback);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var context = function context(name, serverless) {
  var callbackFn = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : _callback2.default;
  return {
    awsRequestId: 'id',
    invokeid: 'id',
    logGroupName: '/aws/lambda/' + name,
    logStreamName: '2015/09/22/[HEAD]13370a84ca4ed8b77c427af260',
    functionVersion: 'HEAD',
    isDefaultFunctionVersion: true,

    functionName: name,
    memoryLimitInMB: '1024',

    succeed: function succeed(result) {
      return callbackFn(serverless)(null, result);
    },
    fail: function fail(error) {
      return callbackFn(serverless)(error);
    },
    done: callbackFn(serverless),

    getRemainingTimeInMillis: function getRemainingTimeInMillis() {
      return 5000;
    }
  };
};

exports.default = context;