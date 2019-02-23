-- Copyright (c) 2016 Davide Corradi - All rights reserved.

local class = require 'hzi.class'
local math = math
local type = type
local error = error
local assert = assert

local filename = ...

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end

	Vector2 = class.declare(filename)

	function Vector2:new(x, y)
		self.x = x or 0
		self.y = y or 0
	end

	function Vector2.__add(v1, v2)
		return Vector2(v1.x + v2.x, v1.y + v2.y)
	end

	function Vector2.__sub(v1, v2)
		return Vector2(v1.x - v2.x, v1.y - v2.y)
	end

	function Vector2.__mul(a, b)
		if type(a) == 'number' then
			return Vector2(a * b.x, a * b.y)
		elseif type(b) == 'number' then
			return Vector2(a.x * b, a.y * b)
		end
		error('One argument must be of type \'' .. Vector2.type() .. '\', one argument must be of type \'number\'')
	end

	function Vector2.__div(v, a)
		if type(a) == 'number' then
			return Vector2(v.x / a, v.y / a)
		end
		error('First argument must be of type \'' .. Vector2.type() .. '\', second argument must be of type \'number\'')
	end

	function Vector2.__tostring(a)
		return '(' .. a.x .. ',' .. a.y .. ')'
	end

	function Vector2:squareNorm()
		return self.x * self.x + self.y * self.y
	end

	function Vector2:norm()
		return math.sqrt(self:squareNorm())
	end

	function Vector2:normalize()
		local norm = self:norm()
		assert(norm ~= 0, 'Cannot normalize with norm equal to 0.')
		self:copy(self / norm)
	end

end