-- Copyright (c) 2016 Davide Corradi - All Rights Reserved

local class = require 'hzi.class'
local table = table
local love = love
local require = require
local ipairs = ipairs

local pairs = pairs
local print = print

local filename = ...

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end

	Animation = class.declare(filename)

	function Animation:new(arg)
		arg = arg or {}
		self._image = arg.image
		self._quads = {}
		self._rects = {}
		for i, frame in ipairs(arg.frames) do
			self:addFrame(frame)
		end
	end



	function Animation:getImage()
		return self._image
	end



	function Animation:setImage(image)
		self._image = image
		self._quads = {}
		for i, rect in ipairs(self._rects) do
			self._quads[i] = love.graphics.newQuad(rect.x, rect.y, rect.w, rect.h,
				self._image:getWidth(), self._image:getHeight())
		end
	end



	function Animation:getQuad(frameNumber)
		return self._quads[frameNumber]
	end



	function Animation:getRect(frameNumber)
		return self._rects[frameNumber]
	end



	function Animation:addFrame(frameRect)
		table.insert(self._rects, frameRect)
		table.insert(self._quads,
			love.graphics.newQuad(frameRect.x, frameRect.y, frameRect.w, frameRect.h,
				self._image:getWidth(), self._image:getHeight()))
	end



	function Animation:getNumberOfFrames()
		return table.getn(self._quads)
	end



	function newAnimation(filename)
		local dataTable = require(filename)
		return Animation(dataTable)
	end


end