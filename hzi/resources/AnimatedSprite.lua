-- Copyright (c) 2016 Davide Corradi - All Rights Reserved

local class = require 'hzi.class'
local hmath = require 'hzi.math'
local love = love

local filename = ...

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end

	AnimatedSprite = class.declare(filename, hmath.Transformable)



	function AnimatedSprite:new(arg)
		arg = arg or {}
		hmath.Transformable.new(self, arg)

		self._animation = arg.animation
		self._frameTime = arg.frameTime or 1
		if arg.duration then
			self:setDuration(arg.duration)
		end
		self._currentTime = 0
		self._currentFrame = 1
		if arg.paused then self._paused = true else self._paused = false end
		if arg.looping then self._looping = true else self._looping = false end
	end



	function AnimatedSprite:getAnimation()
		return self._animation
	end



	function AnimatedSprite:setAnimation(animation)
		self._animation = animation
	end



	function AnimatedSprite:getFrameTime()
		return self._frameTime
	end



	function AnimatedSprite:setFrameTime(time)
		self._frameTime = time
	end



	function AnimatedSprite:getDuration()
		return self._frameTime * self._animation:getNumberOfFrames()
	end



	function AnimatedSprite:setDuration(duration)
		self._frameTime = duration / self._animation:getNumberOfFrames()
	end



	function AnimatedSprite:increaseCurrentFrame()
		self._currentFrame = self._currentFrame + 1
		if self._currentFrame > self._animation:getNumberOfFrames() then
			if self:isLooping() then
				self._currentFrame = 1
			else
				self._currentFrame = self._animation:getNumberOfFrames()
			end
		end
	end


	function AnimatedSprite:setCurrentTime(time)
		self._currentFrame = 1
		self._currentTime = time
	end


	function AnimatedSprite:restart()
		self._currentFrame = 1
		self._currentTime = 0
	end



	function AnimatedSprite:isPaused()
		return self._paused
	end



	function AnimatedSprite:play()
		self._paused = false
	end



	function AnimatedSprite:pause()
		self._paused = true
	end



	function AnimatedSprite:isLooping()
		return self._looping
	end



	function AnimatedSprite:setLooping(value)
		self._looping = value
	end



	function AnimatedSprite:update(dt)
		if not self:isPaused() then
			self._currentTime = self._currentTime + dt
			while self._currentTime >= self._frameTime do
				self._currentTime = self._currentTime - self._frameTime
				self:increaseCurrentFrame()
			end
		end
	end



	function AnimatedSprite:draw()
		love.graphics.pushTransform(self._transform)
		love.graphics.draw(self._animation:getImage(), self._animation:getQuad(self._currentFrame))
		love.graphics.pop()
	end



	function AnimatedSprite:getLocalBounds()
		local rect = self._animation:getRect(self._currentFrame)
		return hmath.Rect(0, 0, rect.w, rect.h)
	end

end