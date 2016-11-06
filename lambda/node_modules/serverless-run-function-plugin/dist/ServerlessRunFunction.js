'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.ServerlessRunFunction = undefined;

var _run = require('./run');

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var ServerlessRunFunction = exports.ServerlessRunFunction = function ServerlessRunFunction(serverless, options) {
  _classCallCheck(this, ServerlessRunFunction);

  this.hooks = {
    'run:run': _run.run.bind(null, serverless, options)
  };

  this.commands = {
    run: {
      usage: 'Runs a serverless function',
      lifecycleEvents: ['run'],
      options: {
        functionName: {
          usage: 'Name of the function to run',
          required: true,
          shortcut: 'f'
        }
      }
    }
  };
};