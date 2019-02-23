-- Includes
local hzi = {}
hzi.class = require 'hzi.class'
require 'test.class.BaseClass1'
local BaseClass1 = BaseClass1



-- Class declaration
local C = hzi.class.declare('SimpleDerivedClass', BaseClass1)
SimpleDerivedClass = C
if setfenv then setfenv(1, C) else _ENV = C end



-- Fields
mValue2 = 5

-- Methods
function new(self, value1, value2)
	BaseClass1.new(self, value1)
	self.mValue2 = value2
end

function getValue(self)
	return self.mValue1 + self.mValue2
end

return C