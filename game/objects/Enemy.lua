-- Copyright (c) 2016 Davide Corradi - All Rights Reserved

local class = require 'hzi.class'
local res = require 'hzi.resources'
local hmt = require 'hzi.math'
local math = math
local love = love
local table = table

local assert = assert
local ipairs = ipairs
local print = print

local filename = ...

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end

	Enemy = class.declare(filename, Entity)

	local WEAPON_RADIUS = 4

	function Enemy:new(arg)

		Entity.new(self, arg)

		self._type = arg.type or 'bomb'
		self._weapons = arg.weapons or {}
		self._waypoints = arg.waypoints or {}
		self._currentwaypoint = 1
		self._speed = arg.speed or 0
		self._activationPoint = arg.activationPoint or 0

		self._visuals = self:generateVisuals(arg.image, arg.animationDuration or 1)
		self._weaponVisual = res.Sprite{
			image = arg.weaponImage,
			rect = hmt.Rect(0,WEAPON_RADIUS*2,WEAPON_RADIUS*2,WEAPON_RADIUS*2),
			origin = hmt.Vector2(WEAPON_RADIUS, WEAPON_RADIUS),
		}
		self._weaponPosOffset = hmt.Vector2(self._visuals:getLocalBounds().w/2, self._visuals:getLocalBounds().h/2)

		self._world = arg.world or nil
		self._loopPath = arg.loopPath or nil

		self._shootSound = arg.shootSound and love.audio.newSource(arg.shootSound) or nil
		self._deathSound = arg.deathSound and love.audio.newSource(arg.deathSound) or nil

	end



	function Enemy:addWeapon(weapon)
		table.insert(self._weapons, weapon)
	end

	

	function Enemy:generateVisuals(image, duration)

		local visuals

		if self._type == 'bomb' then

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

		elseif self._type == 'rock' then

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

		elseif self._type == 'paper' then

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

		elseif self._type == 'scissors' then

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
		elseif self._type == 'points' then
			visuals = res.AnimatedSprite{
				animation = res.Animation{
					image = image,
					frames = {
						hmt.Rect(0, 64, 16, 16),
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
						hmt.Rect(0, 80, 16, 16),
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
						hmt.Rect(0, 96, 16, 16),
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
						hmt.Rect(0, 112, 16, 16),
					},
				},
				duration = duration,
				looping = true,
			}

		end

		return visuals

	end


	function Enemy:getType()
		return self._type
	end


	local function angleVector(angle)
		local anglerad = math.rad(angle)
		return hmt.Vector2(math.cos(anglerad), math.sin(anglerad))
	end


	function Enemy:_onUpdate(dt)

		local wp = self._waypoints[self._currentwaypoint]
		local velocity = hmt.Vector2()

		if wp ~= nil then
			local direction = wp - self:getPosition()
			local distance = direction:norm()
			local movement = self._speed * dt
			if movement < distance then
				velocity = direction * self._speed / distance
			else
				velocity = direction
				self._currentwaypoint = self._currentwaypoint + 1
				if self._loopPath and self._currentwaypoint > table.getn(self._waypoints) then
					self._currentwaypoint = 1
				end
			end
		end

		self:setLinVel(velocity)

		for i, weapon in ipairs(self._weapons) do 
			if not weapon.currentTime then
				weapon.currentTime = 0
			end
			if weapon.currentTime <= 0 then
				weapon.currentTime = weapon.currentTime + weapon.reloadTime
				local bulletPos = self:getPosition() + angleVector(180 + weapon.rotation) * 8
				local bulletVel = angleVector(180 + weapon.rotation) * weapon.bulletSpeed
				self._world:addBullet(createBullet(bulletPos, bulletVel))
				self._shootSound:play()
			end
			weapon.currentTime = weapon.currentTime - dt
		end

		Entity._onUpdate(self, dt)

	end



	function Enemy:_onDraw()
		
		for _, weapon in ipairs(self._weapons) do
			self._weaponVisual:setRotation(weapon.rotation)
			self._weaponVisual:setPosition(self._weaponPosOffset + angleVector(weapon.rotation + 180) * 5)
			self._weaponVisual:draw()
		end
		
		self._visuals:draw()

	end


	function Enemy:die()
		Entity.die(self)
		self._deathSound:play()
	end


	function Enemy:getScore()
		return 100 + table.getn(self._weapons) * 50
	end


	function Enemy:setWorld(world)
		self._world = world
	end


	function Enemy:getActivationPoint()
		return self._activationPoint
	end



	function Enemy:resolveCollision(hero, world, idx)
		if self._type == 'bomb' then
			if not hero:isInvulnerable() then
				world:_destroyEnemy(idx)
				if not hero:isInvincible() then
					world:_destroyHero()
				end
			end
		elseif self._type == 'rock' then
			if hero:isInvincible() then
				world:_destroyEnemy(idx)
			elseif not hero:isInvulnerable() then
				if hero:getShape() == 'rock' then
					world:_destroyEnemy(idx)
					world:_destroyHero()
				elseif hero:getShape() == 'paper' then
					world:_destroyEnemy(idx)
				elseif hero:getShape() == 'scissors' then
					world:_destroyHero()
				elseif hero:getShape() == 'human' then
					world:_destroyHero()
				end
			end
		elseif self._type == 'paper' then
			if hero:isInvincible() then
				world:_destroyEnemy(idx)
			elseif not hero:isInvulnerable() then
				if hero:getShape() == 'rock' then
					world:_destroyHero()
				elseif hero:getShape() == 'paper' then
					world:_destroyEnemy(idx)
					world:_destroyHero()
				elseif hero:getShape() == 'scissors' then
					world:_destroyEnemy(idx)
				elseif hero:getShape() == 'human' then
					world:_destroyHero()
				end
			end
		elseif self._type == 'scissors' then
			if hero:isInvincible() then
				world:_destroyEnemy(idx)
			elseif not hero:isInvulnerable() then
				if hero:getShape() == 'rock' then
					world:_destroyEnemy(idx)
				elseif hero:getShape() == 'paper' then
					world:_destroyHero()
				elseif hero:getShape() == 'scissors' then
					world:_destroyEnemy(idx)
					world:_destroyHero()
				elseif hero:getShape() == 'human' then
					world:_destroyHero()
				end
			end
		elseif self._type == 'points' then
			if hero:isInvincible() or hero:getShape() == 'human' then
				world:_destroyEnemy(idx)
				world:modifyScore(100)
			end
		elseif self._type == 'invincibility' then
			if hero:isInvincible() or hero:getShape() == 'human' then
				world:_destroyEnemy(idx)
				hero:setInvincible()
			end
		elseif self._type == 'life' then
			if hero:isInvincible() or hero:getShape() == 'human' then
				world:_destroyEnemy(idx)
				world:modifyLives(1)
			end
		elseif self._type == 'shield' then
			if hero:isInvincible() or hero:getShape() == 'human' then
				world:_destroyEnemy(idx)
				hero:activateShield()
			end
		end
	end


end