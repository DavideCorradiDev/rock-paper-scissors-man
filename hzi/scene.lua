-- Copyright (c) 2016 Davide Corradi - All rights reserved.

local require = require

-- Package instantiation.
local P = {}
local namespace = ...
if setfenv then setfenv(1, P) else _ENV = P end

require(namespace .. '.Node')(P)

return P