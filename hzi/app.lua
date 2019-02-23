-- Copyright (c) 2016 Davide Corradi - All Rights Reserved

local require = require

-- Package instantiation.
local P = {}
local namespace = ...
if setfenv then setfenv(1, P) else _ENV = P end

require(namespace .. '.State')(P)
require(namespace .. '.StateStack')(P)


return P