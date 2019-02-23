-- Copyright (c) 2016 Davide Corradi - All rights reserved.

local require = require

local P = {}
local namespace = ...
if setfenv then setfenv(1, P) else _ENV = P end

require(namespace .. '.Vector2')(P)
require(namespace .. '.Rect')(P)
require(namespace .. '.TransformMatrix')(P)
require(namespace .. '.Transform')(P)
require(namespace .. '.Transformable')(P)

return P