args        = process.argv.splice(2)

# initialize modules
global.uuid     = require 'node-uuid'
global._        = require 'underscore'
global.Backbone = require 'backbone'
require_tree    = require 'require-tree'

# load app
global.App = require_tree 'app'
global.CymonServer = App

# start app
new CymonServer.Application port: parseInt(args[0])