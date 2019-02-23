-- Copyright (c) 2016 Davide Corradi - All Rights Reserved

local class = require 'hzi.class'
local hmath = require 'hzi.math'
local love = love

local filename = ...

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end

	Sprite = class.declare(filename, hmath.Transformable)



	function Sprite:new(arg)

		arg = arg or {}
		hmath.Transformable.new(self, arg)

		self._image = arg.image
		local imgWidth = self._image and self._image:getWidth() or 0
		local imgHeight = self._image and self._image:getHeight() or 0
		self._rect = class.clone(arg.rect) or hmath.Rect(0, 0, imgWidth, imgHeight)
		self._quad = love.graphics.newQuad(self._rect.x, self._rect.y, self._rect.w, self._rect.h, imgWidth, imgHeight)
		self._color = class.clone(arg.color) or class.clone(Color.White)

	end



	function Sprite:draw()

		love.graphics.pushTransform(self._transform)
		love.graphics.setColorObject(self._color)
		love.graphics.draw(self._image, self._quad)
		love.graphics.pop()

	end



	function Sprite:getImage()
		return self._image
	end



	function Sprite:setImage(image)
		self._image = image
		self._quad = love.graphics.newQuad(self._rect.x, self._rect.y, self._rect.w, self._rect.h,
			self._image:getWidth(), self._image:getHeight())
	end



	function Sprite:getImageRect()
		return self._rect
	end



	function Sprite:setImageRect(rect)
		self._rect = class.clone(rect)
		self._quad = love.graphics.newQuad(self._rect.x, self._rect.y, self._rect.w, self._rect.h,
			self._image:getWidth(), self._image:getHeight())
	end



	function Sprite:getColor()
		return self._color
	end



	function Sprite:setColor(color)
		self._color = class.clone(color)
	end



	function Sprite:getLocalBounds()
		return hmath.Rect(0, 0, self._rect.w, self._rect.h)
	end

end