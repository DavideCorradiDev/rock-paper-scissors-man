-- Copyright (c) 2016 Davide Corradi - All rights reserved.

local class = require 'hzi.class'

local filename = ...

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end

	Rect = class.declare(filename)



	function Rect:new(x, y, w, h)
		self.x = x or 0
		self.y = y or 0
		self.w = w or 0
		self.h = h or 0
	end

end