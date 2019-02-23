-- Copyright (c) 2016 Davide Corradi - All rights reserved.

local require = require

local P = {}
local namespace = ...
if setfenv then setfenv(1, P) else _ENV = P end

require(namespace .. '.ContactShape')(P)
require(namespace .. '.CircleContact')(P)
require(namespace .. '.contactDetection')(P)
require(namespace .. '.Entity')(P)
require(namespace .. '.Hero')(P)
require(namespace .. '.Bullet')(P)
require(namespace .. '.Enemy')(P)
require(namespace .. '.EnemyPrototypes')(P)
require(namespace .. '.PowerUp')(P)
require(namespace .. '.World')(P)

return P