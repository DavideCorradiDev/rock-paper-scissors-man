-- Includes
local hzi = {}
hzi.class = require 'hzi.class'



-- Class Declaration
local C = hzi.class.declare('BaseClass1')
BaseClass1 = C
if setfenv then setfenv(1, C) else _ENV = C end



-- Fields
mValue1 = 0

-- Methods
function new(self, param1)
	self.mValue1 = param1
end

function getValue(self)
	return self.mValue1
end

function setValue(self, param1)
	self.mValue1 = param1
end

return C