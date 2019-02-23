-- Copyright (c) 2016 Davide Corradi - All rights reserved.

local class = require 'hzi.class'
local math = math
local assert = assert
local error = error
local type = type

local print = print

local filename = ...

return function (P)

	if setfenv then setfenv(1, P) else _ENV = P end

	Transform = class.declare(filename)

	function Transform:new(arg)
		arg = arg or {}
		self._position = arg.position and class.clone(arg.position) or Vector2() 
		self._rotation = arg.rotation or 0
		self._scale = arg.scale and class.clone(arg.scale) or Vector2(1, 1)
		self._origin = arg.origin and class.clone(arg.origin) or Vector2()
		self._tMat = TransformMatrix()
		self._tMatUpdated = false
		self._tMatInv = TransformMatrix()
		self._tMatInvUpdated = false
	end

	function Transform:equals(other)
		return self:type() == other:type() and
			self._position:equals(other._position) and
			self._rotation == other._rotation and
			self._origin:equals(other._origin) and
			self._scale:equals(other._scale)
	end

	function Transform:getPosition()
		return self._position:clone()
	end

	function Transform:setPosition(a, b)
		self._tMatUpdated = false
		self._tMatInvUpdated = false
		if class.type(a) == Vector2:type() and b == nil then
			self._position:copy(a)
		elseif type(a) == 'number' and type(b) == 'number' then
			self._position.x = a
			self._position.y = b
		else
			error('Invalid arguments.')
		end
	end

	function Transform:translate(a, b)
		if class.type(a) == Vector2:type() and b == nil then
			self:setPosition(self._position + a)
		elseif type(a) == 'number' and type(b) == 'number' then
			self:setPosition(self._position + Vector2(a, b))
		else
			error('Invalid arguments.')
		end
	end

	function Transform:getRotation()
		return self._rotation
	end

	function Transform:setRotation(a)
		self._tMatUpdated = false
		self._tMatInvUpdated = false
		if type(a) == 'number' then
			self._rotation = a
		else
			error('Invalid arguments.')
		end
	end

	function Transform:rotate(a)
		if type(a) == 'number' then
			self:setRotation(self._rotation + a)
		else
			error('Invalid arguments.')
		end
	end

	function Transform:getScale()
		return self._scale:clone()
	end

	function Transform:setScale(a, b)
		self._tMatUpdated = false
		self._tMatInvUpdated = false
		if class.type(a) == Vector2:type() and b == nil then
			self._scale:copy(a)
		elseif type(a) == 'number' and type(b) == 'number' then
			self._scale.x = a
			self._scale.y = b
		else
			error('Invalid arguments.')
		end
	end

	function Transform:scale(a, b)
		if class.type(a) == Vector2:type() and b == nil then
			self:setScale(self._scale.x * a.x, self._scale.y * a.y)
		elseif type(a) == 'number' and type(b) == 'number' then
			self:setScale(self._scale.x * a, self._scale.y * b)
		else
			error('Invalid arguments.')
		end
	end

	function Transform:getOrigin()
		return self._origin:clone()
	end

	function Transform:setOrigin(a, b)
		self._tMatUpdated = false
		self._tMatInvUpdated = false
		if class.type(a) == Vector2:type() and b == nil then
			self._origin:copy(a)
		elseif type(a) == 'number' and type(b) == 'number' then
			self._origin.x = a
			self._origin.y = b
		else
			error('Invalid arguments.')
		end
	end

	function Transform:moveOrigin(a, b)
		if class.type(a) == Vector2:type() and b == nil then
			self:setOrigin(self._origin + a)
		elseif type(a) == 'number' and type(b) == 'number' then
			self:setOrigin(self._origin + Vector2(a, b))
		else
			error('Invalid arguments.')
		end
	end

	function Transform:updateTransformMatrix()
		if not self._tMatUpdated then

			local angle = - self._rotation * math.pi / 180
			local cos = math.cos(angle)
			local sin = math.sin(angle)
			local sxc = self._scale.x * cos
			local syc = self._scale.y * cos
			local sxs = self._scale.x * sin
			local sys = self._scale.y * sin
			local tx = - self._origin.x * sxc - self._origin.y * sys + self._position.x
			local ty = self._origin.x *sxs - self._origin.y * syc + self._position.y

			self._tMat = TransformMatrix(
				sxc, sys, tx,
				-sxs, syc, ty,
				0, 0, 1
			)

			self._tMatUpdated = true
		end
	end

	function Transform:getTransformMatrix()
		self:updateTransformMatrix()
		return self._tMat:clone()
	end

	function Transform:updateInverseTransformMatrix()
		self:updateTransformMatrix()
		if not self._tMatInvUpdated then
			self._tMatInv = self._tMat:getInverse()
			self._tMatInvUpdated = true
		end
	end

	function Transform:getInverseTransformMatrix()
		self:updateInverseTransformMatrix()
		return self._tMatInv:clone()

	end

	function Transform:__tostring()
		return 'Transform:\n' ..
			'\t position = ' .. self._position:tostring() .. '\n' ..
			'\t rotation = ' .. self._rotation .. '\n' ..
			'\t scale = ' .. self._scale:tostring() .. '\n' ..
			'\t origin = ' .. self._origin:tostring() .. '\n'
	end

end