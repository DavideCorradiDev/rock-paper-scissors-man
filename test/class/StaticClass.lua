-- Includes
local hzi = {}
hzi.class = require 'hzi.class'



-- Class Declaration
local C = hzi.class.declare('StaticClass')
StaticClass = C
if setfenv then setfenv(1, C) else _ENV = C end


mField = 0

local staticField = 0

function new(self, value)
	self.mField = value
end

function setField(self, value)
	self.mField = value
end

function getField(self)
	return self.mField
end

function setStaticField(value)
	staticField = value
end

function getStaticField()
	return staticField
end


return C