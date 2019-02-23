-- Copyright (c) 2016 Davide Corradi - All Rights Reserved

local class = require 'hzi.class'
local hmt = require 'hzi.math'
local scene = require 'hzi.scene'

local assert = assert

local filename = ...

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end

	Entity = class.declare(filename, scene.Node)

	function Entity:new(arg)

		scene.Node.new(self, arg)

		self._linVel = arg.linVel and class.clone(arg.linVel) or hmt.Vector2()
		self._linAcc = arg.linAcc and class.clone(arg.linAcc) or hmt.Vector2()

		self._contactShape = arg.contactShape or nil
		self._contactShape:setPosition(self:getGlobalPosition())
		
	end



	function Entity:setLinVel(val)
		assert(class.typeOf(val, hmt.Vector2:type()))
		self._linVel = val
	end



	function Entity:setLinAcc(val)
		assert(class.typeOf(val, hmt.Vector2:type()))
		self._linAcc = val
	end



	function Entity:getContactShape()
		return self._contactShape
	end



	function Entity:_onUpdate(dt)

		self:translate(self._linVel * dt + 0.5 * self._linAcc * dt * dt)
		self._linVel = self._linVel + self._linAcc * dt

		self._contactShape:setPosition(self:getGlobalPosition())

	end


	function Entity:die()
		self:delete()
	end

end