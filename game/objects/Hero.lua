-- Copyright (c) 2016 Davide Corradi - All Rights Reserved

local class = require 'hzi.class'
local res = require 'hzi.resources'
local hmt = require 'hzi.math'
local love = love
local table = table
local math = math

local USING_JOYSTICK = USING_JOYSTICK

local print = print
local tostring = tostring
local playerJoystick = playerJoystick
print(playerJoystick)

local filename = ...

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end

	Hero = class.declare(filename, Entity)

	local invincibilityTime = 6
	local invulnerabilityTime = 1
	local shieldRadius = 10
	local shieldColor = {r = 171, g = 255, b = 171, a = 120}


	function Hero:new(arg)

		Entity.new(self, arg)

		self._shape = 'human'
		self._visuals = self:_generateVisuals(arg.image, arg.animationDuration or 1)
		self._speed = arg.speed or 0

		self._transformSound = arg.transformSound and love.audio.newSource(arg.transformSound) or nil
		self._deathSound = {
			human = love.audio.newSource(arg.humanDeathSound),
			rock = love.audio.newSource(arg.rockDeathSound),
			paper = love.audio.newSource(arg.paperDeathSound),
			scissors = love.audio.newSource(arg.scissorsDeathSound),
		}
		self._shieldSound = arg.shieldSound and love.audio.newSource(arg.shieldSound) or nil

		self._inputVel = hmt.Vector2()

		self._invincibilityTimer = 0
		self._shielded = false
		self._invulnerabilityTimer = 0

		self:addCallback('keypressed', self._onKeyPressed)
		self:addCallback('keyreleased', self._onKeyReleased)
		self:addCallback('gamepadpressed', self._onGamepadPressed)
		-- self:addCallback('joystickadded', self._onJoystickAdded)

		

	end


	function Hero:_generateVisuals(image, duration)
		visuals = {}

		visuals.human = res.AnimatedSprite{
			animation = res.Animation{
				image = image,
				frames = {
					hmt.Rect(0, 0, 16, 16),
				},
			},
			duration = duration,
			looping = true,
		}

		visuals.rock = res.AnimatedSprite{
			animation = res.Animation{
				image = image,
				frames = {
					hmt.Rect(0, 16, 16, 16),
				},
			},
			duration = duration,
			looping = true,
		}

		visuals.paper = res.AnimatedSprite{
			animation = res.Animation{
				image = image,
				frames = {
					hmt.Rect(0, 32, 16, 16),
				},
			},
			duration = duration,
			looping = true,
		}

		visuals.scissors = res.AnimatedSprite{
			animation = res.Animation{
				image = image,
				frames = {
					hmt.Rect(0, 48, 16, 16),
				},
			},
			duration = duration,
			looping = true,
		}

		visuals.invincible = res.AnimatedSprite{
			animation = res.Animation{
				image = image,
				frames = {
					hmt.Rect(0, 64, 16, 16),
				},
			},
			duration = duration,
			looping = true,
		}

		visuals.shield = res.AnimatedSprite{
			animation = res.Animation{
				image = image,
				frames = {
					hmt.Rect(0, 80, 16, 16),
				},
			},
			duration = duration,
			looping = true,
		}

		return visuals

	end


	function Hero:getShape()
		return self._shape
	end


	function Hero:setShape(shape)
		self._shape = shape
		self._visuals[self._shape]:restart()
	end


	function Hero:changeShape(shape)

		if self._shape ~= shape then 
			self._shape = shape
			self._visuals[self._shape]:restart()
			if self._transformSound then
				self._transformSound:rewind()
				self._transformSound:play()
			end
		end

	end



	function Hero:_onUpdate(dt)

		self:_setInputVel()

		if (self._invulnerabilityTimer > 0.25 * invulnerabilityTime and 
			self._invulnerabilityTimer <= 0.5 * invulnerabilityTime) or
			(self._invulnerabilityTimer > 0.75 * invulnerabilityTime and 
			self._invulnerabilityTimer <= 1 * invulnerabilityTime) then

			self:setVisible(false)

		else
			self:setVisible(true)
		end

		self._invulnerabilityTimer = self._invulnerabilityTimer - dt


		self._linVel = self._linVel + self._inputVel
		Entity._onUpdate(self, dt)
		self._linVel = self._linVel - self._inputVel
		self._invincibilityTimer = self._invincibilityTimer - dt
		self._visuals[self._shape]:update(dt)

	end


	function Hero:_setInputVel()

		self._inputVel.x = 0
		self._inputVel.y = 0

		if love.keyboard.isScancodeDown('w') then
			self._inputVel.y = self._inputVel.y - self._speed
		end
		if love.keyboard.isScancodeDown('s') then
			self._inputVel.y = self._inputVel.y + self._speed
		end
		if love.keyboard.isScancodeDown('a') then
			self._inputVel.x = self._inputVel.x - self._speed
		end
		if love.keyboard.isScancodeDown('d') then
			self._inputVel.x = self._inputVel.x + self._speed
		end	

		local tol = 0.2

		if playerJoystick[1] then
			local lx = playerJoystick[1]:getGamepadAxis('leftx')
			local ly = playerJoystick[1]:getGamepadAxis('lefty')
			if math.abs(lx) > tol then self._inputVel.x = lx * self._speed end
			if math.abs(ly) > tol then self._inputVel.y = ly * self._speed end
		end

	end


	function Hero:_onKeyPressed(msg)

		-- if msg.scancode == 'w' then
		-- 	self._inputVel.y = self._inputVel.y - self._speed
		-- elseif msg.scancode == 's' then
		-- 	self._inputVel.y = self._inputVel.y + self._speed
		-- elseif msg.scancode == 'a' then
		-- 	self._inputVel.x = self._inputVel.x - self._speed
		-- elseif msg.scancode == 'd' then
		-- 	self._inputVel.x = self._inputVel.x + self._speed
		-- end	

		if msg.scancode == 'i' then
			self:changeShape('human')
		elseif msg.scancode == 'j' then
			self:changeShape('rock')
		elseif msg.scancode == 'k' then
			self:changeShape('paper')
		elseif msg.scancode == 'l' then
			self:changeShape('scissors')
		end

	end


	function Hero:_onGamepadPressed(msg)
		if msg.button == 'y' then
			self:changeShape('human')
		elseif msg.button == 'x' then
			self:changeShape('rock')
		elseif msg.button == 'a' then
			self:changeShape('paper')
		elseif msg.button == 'b' then
			self:changeShape('scissors')
		end
	end


	function Hero:_onKeyReleased(msg)

		-- if msg.scancode == 'w' then
		-- 	-- self._inputVel.y = self._inputVel.y + self._speed
		-- elseif msg.scancode == 's' then
		-- 	-- self._inputVel.y = self._inputVel.y - self._speed
		-- elseif msg.scancode == 'a' then
		-- 	-- self._inputVel.x = self._inputVel.x + self._speed
		-- elseif msg.scancode == 'd' then
		-- 	-- self._inputVel.x = self._inputVel.x - self._speed
		-- end	

	end


	function Hero:_onDraw()

		self._visuals[self._shape]:draw()

		if self:isShielded() then
			-- self._visuals.shield:draw()
			love.graphics.setColor(shieldColor.r, shieldColor.g, shieldColor.b, shieldColor.a)
			love.graphics.circle('fill', self:getOrigin().x, self:getOrigin().y, shieldRadius, 10)
			love.graphics.setColor(255, 255, 255, 255)
		end
		if self:isInvincible() then
			self._visuals.invincible:draw()
		end

	end


	function Hero:die()
		Entity.die(self)
		self._deathSound[self._shape]:play()
	end


	function Hero:setInvincible()
		self._invincibilityTimer = invincibilityTime
	end


	function Hero:isInvincible()
		return self._invincibilityTimer > 0
	end



	function Hero:activateShield()
		if not self._shielded then
			self._shielded = true
			self._shieldSound:play()
		end
	end


	function Hero:isShielded()
		return self._shielded
	end


	function Hero:deactivateShield()
		if self._shielded then
			self._shielded = false
			self._shieldSound:play()
			self._invulnerabilityTimer = invulnerabilityTime
		end
	end


	function Hero:isInvulnerable()
		return self._invulnerabilityTimer > 0
	end

end