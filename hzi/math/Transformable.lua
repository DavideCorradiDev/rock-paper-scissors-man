-- Copyright (c) 2016 Davide Corradi - All rights reserved.

local class = require 'hzi.class'

local print = print

local filename = ...

return function (P)

	if setfenv then setfenv(1, P) else _ENV = P end

	Transformable = class.declare(filename)

	function Transformable:new(arg)
		arg = arg or {}
		self._transform = Transform(arg)
	end

	function Transformable:getPosition()
		return self._transform:getPosition()
	end

	function Transformable:setPosition(a, b)
		self._transform:setPosition(a, b)
	end

	function Transformable:translate(a, b)
		self._transform:translate(a, b)
	end

	function Transformable:getRotation()
		return self._transform:getRotation()
	end

	function Transformable:setRotation(a)
		self._transform:setRotation(a)
	end

	function Transformable:rotate(a)
		self._transform:rotate(a)
	end

	function Transformable:getScale()
		return self._transform:getScale()
	end

	function Transformable:setScale(a, b)
		self._transform:setScale(a, b)
	end

	function Transformable:scale(a, b)
		self._transform:scale(a, b)
	end

	function Transformable:getOrigin()
		return self._transform:getOrigin()
	end

	function Transformable:setOrigin(a, b)
		self._transform:setOrigin(a, b)
	end

	function Transformable:moveOrigin(a, b)
		self._transform:moveOrigin(a, b)
	end


end