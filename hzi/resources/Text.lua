-- Copyright (c) 2016 Davide Corradi - All Rights Reserved

local class = require 'hzi.class'
local hmath = require 'hzi.math'
local love = love
local math = math

local filename = ...

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end

	Text = class.declare(filename, hmath.Transformable)



	function Text:new(arg)

		arg = arg or {}
		hmath.Transformable.new(self, arg)

		self._font = arg.font or love.graphics.newFont()
		self._string = arg.string or ''
		self._color = class.clone(arg.color) or class.clone(Color.White)

	end



	function Text:draw()
		love.graphics.pushTransform(self._transform)
		love.graphics.setColorObject(self._color)
		love.graphics.setFont(self._font)
		love.graphics.print(self._string)
		love.graphics.pop()
	end



	function Text:getFont()
		return self._font
	end



	function Text:setFont(font)
		self._font = font
	end



	function Text:getColor()
		return self._color
	end



	function Text:setColor(color)
		self._color = class.clone(color)
	end



	function Text:getString()
		return self._string
	end



	function Text:setString(string)
		self._string = string
	end



	function Text:getLocalBounds()
		return hmath.Rect(0, 0, self._font:getWidth(self._string), self._font:getHeight(self_string)) 
	end


	function Text:centerOrigin()
		local bounds = self:getLocalBounds()
		self:setOrigin(math.floor(bounds.w/2), math.floor(bounds.h/2))
	end

end