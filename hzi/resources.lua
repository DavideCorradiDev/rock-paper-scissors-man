-- Copyright (c) 2016 Davide Corradi - All Rights Reserved

local require = require

local namespace = ...

-- Package instantiation.
local P = {}
if setfenv then setfenv(1, P) else _ENV = P end

require(namespace .. '.resourceTables')(P)
require(namespace .. '.Color')(P)
require(namespace .. '.Sprite')(P)
require(namespace .. '.Text')(P)
require(namespace .. '.Animation')(P)
require(namespace .. '.AnimatedSprite')(P)

return P