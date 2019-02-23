local unittest = require 'hzi.unittest'
require('test.utilsTest')
require('test.classTest')
require('test.mathTest')
require('test.messageTest')
require('test.sceneTest')

os.exit(unittest.LuaUnit.run())