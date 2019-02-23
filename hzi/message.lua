-- Copyright (c) 2016 Davide Corradi - All rights reserved.

local require = require

local P = {}
local namespace = ...
if setfenv then setfenv(1, P) else _ENV = P end

require(namespace .. '.loveEventToMessage')(P)
require(namespace .. '.MessageQueue')(P)
require(namespace .. '.MessageHandler')(P)

return P