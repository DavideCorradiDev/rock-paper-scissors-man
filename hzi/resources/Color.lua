-- Copyright (c) 2016 Davide Corradi - All Rights Reserved

local class = require 'hzi.class'

local filename = ...

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end

	Color = class.declare(filename)



	function Color:new(r, g, b, a)
		self.r = r or 255
		self.g = g or 255
		self.b = b or 255
		self.a = a or 255
	end



	Color.White = Color(255, 255, 255, 255)
	Color.Black = Color(0, 0, 0, 255)
	Color.Red = Color(255, 0, 0, 255)
	Color.Green = Color(0, 255, 0, 255)
	Color.Blue = Color(0, 0, 255, 255)
	Color.Yellow = Color(255, 255, 0, 255)
	
end