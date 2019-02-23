-- Copyright (c) 2016 Davide Corradi - All rights reserved.

local class = require 'hzi.class'
local math = math
local errors = require 'hzi.errors'
local assert = assert
local ipairs = ipairs
local print = print

local filename = ...

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end



	TransformMatrix = class.declare(filename)



	function TransformMatrix:new(t11, t12, t13, t21, t22, t23, t31, t32, t33)
		self._mat = {
			t11 or 0, t21 or 0, t31 or 0,
			t12 or 0, t22 or 0, t32 or 0,
			t13 or 0, t23 or 0, t33 or 0,
		}
	end



	function TransformMatrix:getInverse()
		local det = 
			self._mat[1] * (self._mat[9] * self._mat[5] - self._mat[6] * self._mat[8]) -
			self._mat[2] * (self._mat[9] * self._mat[4] - self._mat[6] * self._mat[7]) +
			self._mat[3] * (self._mat[8] * self._mat[4] - self._mat[5] * self._mat[7])
		assert(det ~= 0, '\'getInverse\': matrix determinant equal to 0, cannot invert.')

		return TransformMatrix(
			 (self._mat[9] * self._mat[5] - self._mat[6] * self._mat[8]) / det,
			-(self._mat[9] * self._mat[4] - self._mat[6] * self._mat[7]) / det,
			 (self._mat[8] * self._mat[4] - self._mat[5] * self._mat[7]) / det,
			-(self._mat[9] * self._mat[2] - self._mat[3] * self._mat[8]) / det,
			 (self._mat[9] * self._mat[1] - self._mat[3] * self._mat[7]) / det,
			-(self._mat[8] * self._mat[1] - self._mat[2] * self._mat[7]) / det,
			 (self._mat[6] * self._mat[2] - self._mat[3] * self._mat[5]) / det,
			-(self._mat[6] * self._mat[1] - self._mat[3] * self._mat[4]) / det,
			 (self._mat[5] * self._mat[1] - self._mat[2] * self._mat[4]) / det
		)

	end



	function TransformMatrix.multiply(a, b)
		return TransformMatrix(
			a._mat[1] * b._mat[1] + a._mat[4] * b._mat[2] + a._mat[7] * b._mat[3],
			a._mat[1] * b._mat[4] + a._mat[4] * b._mat[5] + a._mat[7] * b._mat[6],
			a._mat[1] * b._mat[7] + a._mat[4] * b._mat[8] + a._mat[7] * b._mat[9],
			a._mat[2] * b._mat[1] + a._mat[5] * b._mat[2] + a._mat[8] * b._mat[3],
			a._mat[2] * b._mat[4] + a._mat[5] * b._mat[5] + a._mat[8] * b._mat[6],
			a._mat[2] * b._mat[7] + a._mat[5] * b._mat[8] + a._mat[8] * b._mat[9],
			a._mat[3] * b._mat[1] + a._mat[6] * b._mat[2] + a._mat[9] * b._mat[3],
			a._mat[3] * b._mat[4] + a._mat[6] * b._mat[5] + a._mat[9] * b._mat[6],
			a._mat[3] * b._mat[7] + a._mat[6] * b._mat[8] + a._mat[9] * b._mat[9]
		)
	end



	function TransformMatrix:transformPoint(v)
		return Vector2(
			self._mat[1] * v.x + self._mat[4] * v.y + self._mat[7],
			self._mat[2] * v.x + self._mat[5] * v.y + self._mat[8]
		)
	end



	function TransformMatrix:__mul(b)
		if class.typeOf(b, TransformMatrix.type()) then
			return self:multiply(b)
		elseif class.typeOf(b, Vector2.type()) then
			return self:transformPoint(b)
		end
	end



	function TransformMatrix:combine(t)
		self:copy(TransformMatrix.multiply(self, t))
		return self
	end

	

	function TransformMatrix:translate(t)
		return self:combine(TransformMatrix(
			1,0,t.x,
			0,1,t.y,
			0,0,1
		))
	end



	function TransformMatrix:rotate(r, center)
		center = center or Vector2(0,0)
		local rRad = r * math.pi / 180
		local c = math.cos(rRad)
		local s = math.sin(rRad)
		return self:combine(TransformMatrix(
			c, -s, center.x * (1 - c) + center.y * s,
			s, c, center.y * (1 - c) - center.x * s,
			0, 0, 1
			))
	end



	function TransformMatrix:scale(s, center)
		center = center or Vector2(0,0)
		return self:combine(TransformMatrix(
			s.x, 0, center.x * (1 - s.x),
			0, s.y, center.y * (1 - s.y),
			0, 0, 1
		))
	end



	function TransformMatrix:__tostring()
		
		local stringout = ''
		for c = 1,3 do
			stringout = stringout .. '| '
			for r = 1,3 do
				stringout = stringout .. self._mat[(r-1)*3 + c] .. ' '
			end
			stringout = stringout .. '|\n'
		end
		return stringout

	end

end