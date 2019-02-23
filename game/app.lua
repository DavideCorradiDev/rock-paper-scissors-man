-- Copyright (c) 2016 Davide Corradi - All rights reserved.

local require = require

local P = {}
local namespace = ...
if setfenv then setfenv(1, P) else _ENV = P end

require(namespace .. '.PlayState')(P)
require(namespace .. '.MainMenu')(P)
require(namespace .. '.PauseMenu')(P)
require(namespace .. '.LevelCompleted')(P)
require(namespace .. '.GameCompleted')(P)
require(namespace .. '.LoseState')(P)
require(namespace .. '.HelpScreen')(P)

return P