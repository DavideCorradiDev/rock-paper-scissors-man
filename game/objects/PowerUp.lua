-- Copyright (c) 2016 Davide Corradi - All Rights Reserved

local class = require 'hzi.class'
local res = require 'hzi.resources'
local hmt = require 'hzi.math'
local love = love

local filename = ...

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end

	PowerUp = class.declare(filename, Entity)

	local sounds = {
		points = love.audio.newSource(res.sound.pointsPU),
		invincibility = love.audio.newSource(res.sound.invincibilityPU),
		life = love.audio.newSource(res.sound.lifePU),
		shield = love.audio.newSource(res.sound.shieldPU),
	}

	function PowerUp:new(arg)

		Entity.new(self, arg)

		self._type = arg.type or 'points'
		self._visual = self:_generateVisual(arg.image, arg.animationDuration)

	end

	function PowerUp:_generateVisual(image, animationDuration)

		local visuals

		if self._type == 'points' then
			visuals = res.AnimatedSprite{
				animation = res.Animation{
					image = image,
					frames = {
						hmt.Rect(0, 0, 16, 16),
					},
				},
				duration = duration,
				looping = true,
			}
		elseif self._type == 'invincibility' then
			visuals = res.AnimatedSprite{
				animation = res.Animation{
					image = image,
					frames = {
						hmt.Rect(0, 16, 16, 16),
					},
				},
				duration = duration,
				looping = true,
			}
		elseif self._type == 'life' then
			visuals = res.AnimatedSprite{
				animation = res.Animation{
					image = image,
					frames = {
						hmt.Rect(0, 32, 16, 16),
					},
				},
				duration = duration,
				looping = true,
			}
		elseif self._type == 'shield' then
			visuals = res.AnimatedSprite{
				animation = res.Animation{
					image = image,
					frames = {
						hmt.Rect(0, 48, 16, 16),
					},
				},
				duration = duration,
				looping = true,
			}

		end

		return visuals

	end

	function PowerUp:_onDraw()
		self._visual:draw()
	end

	function PowerUp:consume(hero, world)

		self:die()

		if self._type == 'points' then
			world:modifyScore(100)
		elseif self._type == 'invincibility' then
			hero:setInvincible()
		elseif self._type == 'life' then
			world:modifyLives(1)
		elseif self._type == 'shield' then
			hero:activateShield()
		end
		sounds[self._type]:rewind()
		sounds[self._type]:play()
	end


	local RADIUS = 7

	function createPowerUp(type, x, y)
		return PowerUp{
			position = hmt.Vector2(x, y),
			origin = hmt.Vector2(RADIUS, RADIUS),
			contactShape = CircleContact{radius = RADIUS},
			type = type,
			image = res.image.powerup,
		}
	end

end