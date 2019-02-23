-- Copyright (c) 2016 Davide Corradi - All Rights Reserved

local class = require 'hzi.class'
local hmt = require 'hzi.math'

local filename = ...

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end

	CircleContact = class.declare(filename, ContactShape)

	function CircleContact:new(arg)

		ContactShape.new(self, arg)

		self._radius = arg.radius or 0

	end

	function CircleContact:getRadius()
		return self._radius
	end

	function CircleContact:getUp()
		return self:getPosition().y - self._radius
	end

	function CircleContact:getDown()
		return self:getPosition().y + self._radius
	end

	function CircleContact:getLeft()
		return self:getPosition().x - self._radius
	end

	function CircleContact:getRight()
		return self:getPosition().x + self._radius
	end

end