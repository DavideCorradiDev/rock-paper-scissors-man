-- Includes
local hzi = {}
hzi.class = require 'hzi.class'



-- Class Declaration
local C = hzi.class.declare('BaseClass2')
BaseClass2 = C
if setfenv then setfenv(1, C) else _ENV = C end



-- Fields
mValue2 = 3

-- Methods
function new(self, param2)
	self.mValue2 = param2
end

function getOtherValue(self)
	return self.mValue2
end

function setOtherValue(self, param2)
	self.mValue2 = param2
end

return C