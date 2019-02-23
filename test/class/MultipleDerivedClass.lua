-- Includes
local hzi = {}
hzi.class = require 'hzi.class'
require 'test.class.BaseClass1'
local BaseClass1 = BaseClass1
require 'test.class.BaseClass2'
local BaseClass2 = BaseClass2



-- Class declaration
local C = hzi.class.declare('MultipleDerivedClass', BaseClass1, BaseClass2)
MultipleDerivedClass = C
if setfenv then setfenv(1, C) else _ENV = C end



-- Methods
function new(self, value1, value2)
	BaseClass1.new(self, value1)
	BaseClass2.new(self, value2)
end

function getValue(self)
	return self.mValue1 * self.mValue2
end



return C