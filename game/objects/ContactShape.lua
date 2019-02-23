-- Copyright (c) 2016 Davide Corradi - All Rights Reserved

local class = require 'hzi.class'
local hmt = require 'hzi.math'

local filename = ...

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end

	ContactShape = class.declare(filename, hmt.Transformable)

	function ContactShape:new(arg)

		hmt.Transformable.new(self, arg)

	end

	function ContactShape:getUp()

	end

	function ContactShape:getDown()

	end

	function ContactShape:getLeft()

	end

	function ContactShape:getRight()

	end

end