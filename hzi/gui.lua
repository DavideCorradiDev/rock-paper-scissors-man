-- Copyright (c) 2016 Davide Corradi - All rights reserved.

local require = require

-- Package instantiation.
local P = {}
local namespace = ...
if setfenv then setfenv(1, P) else _ENV = P end

require(namespace .. '.Component')(P)
require(namespace .. '.Container')(P)
require(namespace .. '.Button')(P)
require(namespace .. '.TextInput')(P)

return P