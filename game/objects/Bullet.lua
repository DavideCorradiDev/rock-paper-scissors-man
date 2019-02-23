-- Copyright (c) 2016 Davide Corradi - All Rights Reserved

local class = require 'hzi.class'
local res = require 'hzi.resources'
local hmt = require 'hzi.math'
local love = love

local filename = ...

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end

	Bullet = class.declare(filename, Entity)
	local BULLET_RADIUS = 4

	function Bullet:new(arg)

		Entity.new(self, arg)

		self._visual = res.Sprite{ 
			image = res.image.bullet,
			rect = hmt.Rect(0, 0, BULLET_RADIUS*2, BULLET_RADIUS*2)
		}

		self._deathSound = love.audio.newSource(res.sound.bombDeath)

	end



	function Bullet:_onDraw()
		self._visual:draw()
	end


	

	function createBullet(position, velocity)

		return Bullet{
			position = position,
			origin = hmt.Vector2(BULLET_RADIUS, BULLET_RADIUS),
			linVel = velocity,
			contactShape = CircleContact{ radius = BULLET_RADIUS - 1}
		}

	end



	function Bullet:die()
		Entity.die(self)
		self._deathSound:play()

	end

end