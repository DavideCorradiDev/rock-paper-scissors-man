-- Copyright (c) 2016 Davide Corradi - All Rights Reserved

local class = require 'hzi.class'
local scene = require 'hzi.scene'
local res = require 'hzi.resources'
local hmt = require 'hzi.math'

local filename = ...

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end

	World = class.declare(filename, scene.Node)



	function World:new(arg)

		scene.Node.new(self, arg)

		self._width = arg.width or 0
		self._height = arg.height or 0

		self._background = res.Sprite(arg) or res.Sprite()
		self._background:setImageRect(hmt.Rect(0, 0, self._width, self._height))

	end



	function World:getWidth()
		return self._width
	end



	function World:setWidth(val)
		self._width = val
		self._background:setImageRect(hmt.Rect(0, 0, self._width, self._height))
	end


	function World:getHeight()
		return self._height
	end



	function World:_onDraw()
		self._background:draw()
	end

end