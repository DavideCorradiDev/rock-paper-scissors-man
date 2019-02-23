-- Copyright (c) 2016 Davide Corradi - All Rights Reserved

local class = require 'hzi.class'
local app = require 'hzi.app'
local obj = require 'game.objects'
local res = require 'hzi.resources'
local hmt = require 'hzi.math'
local scene = require 'hzi.scene'
local lev = require 'game.levels'
local love = love
local table = table
local math = math

local ipairs = ipairs
local print = print

local filename = ...

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end

	PlayState = class.declare(filename, app.State)

	function PlayState:new()

		app.State.new(self)

		self._godmode = false

		self._scrollSpeed = self._godmode and 200 or 64
		self._heroRadius = 8
		self._playerSpeed = 128
		self._worldHeight = 16 * 12
		self._worldWidth = 0
		self._screenWidth = 16 * 18
		self._scoreForLife = 15000
		self._playerBasePosition = hmt.Vector2(2 * self._heroRadius, 0.5 * self._worldHeight)
		self._music = res.music.music
		self._musicDelay = 1
		self._musicCurrentDelay = self._musicDelay
		self._music:setLooping(true)

		self._score = 0
		self._lifeScore = 0
		self._scoreText = res.Text{
			position = hmt.Vector2(8, self._worldHeight + 6)
		}

		self._lives = 2
		self._livesText = res.Text{
			position = hmt.Vector2(124, self._worldHeight + 6)
		}

		self._currentLevel = 1
		self._levelText = res.Text{
			position = hmt.Vector2(220, self._worldHeight + 6)
		}

		res.image.backgroundstars:setWrap('repeat', 'repeat')

		self._scene = obj.World{
			image = res.image.backgroundstars,
			height = self._worldHeight,
			width = self._worldWidth,
		}

		self._hero = obj.Hero{

			position = self._playerBasePosition,
			origin = hmt.Vector2(self._heroRadius, self._heroRadius),

			linVel = hmt.Vector2(self._scrollSpeed),
			speed = self._playerSpeed,

			image = res.image.hero,
			animationDuration = 0.5,

			transformSound = res.sound.transform,
			rockDeathSound = res.sound.rockDeath,
			paperDeathSound = res.sound.paperDeath,
			scissorsDeathSound = res.sound.scissorsDeath,
			humanDeathSound = res.sound.humanDeath,
			shieldSound = res.sound.shield,

			contactShape = obj.CircleContact{
				origin = hmt.Vector2(self._heroRadius-2, self._heroRadius-2),
				radius = self._heroRadius,
			}
		}

		self._lifeUpSound = love.audio.newSource(res.sound.lifePU)

		self._cameraPosition = 0
		self._enemies = {}
		self._powerups = {}
		self._bullets = {}

		self:startLevel(self._currentLevel)



	end



	function PlayState:update(dt)
		self:checkVictory()
		if self._restartLevel then
			self:startLevel(self._currentLevel)
			self._restartLevel = false
		end
		if not self._music:isPlaying() then
			self._musicCurrentDelay = self._musicCurrentDelay - dt
			if self._musicCurrentDelay <= 0 then
				self._musicCurrentDelay = self._musicDelay
				self._music:play()
			end
		end
		self._scene:update(dt)
		self:_checkContacts()
		self._cameraPosition = self._cameraPosition + self._scrollSpeed * dt
		self:_boundEntity(self._hero)
		self:_updateEnemies()
		self:_updateBullets()
		self._scene:removeDeletedChildren()
	end



	function PlayState:handleMessage(msg)

		if msg.tag == 'keypressed' then
			if msg.key == 'escape' then
				self._music:pause()
				app.push(PauseMenu(self._music))
			end
		elseif msg.tag == 'gamepadpressed' then
			if msg.button == 'start' then
				self._music:pause()
				app.push(PauseMenu(self._music))
			end
		end

		self._scene:handleMessage(msg)
	end



	function PlayState:draw()
		love.graphics.push()
		love.graphics.translate(-self._cameraPosition, 0)
		self._scene:draw()
		love.graphics.pop()
		self._livesText:setString('LIVES: ' .. self._lives)
		self._livesText:draw()
		self._scoreText:setString('SCORE: ' .. self._score)
		self._scoreText:draw()
		self._levelText:setString('LEVEL: ' .. self._currentLevel)
		self._levelText:draw()
	end



	function PlayState:_boundEntity(entity)

		local cs = entity:getContactShape()

		if cs then
			local upMargin = cs:getUp()
			local downMargin = cs:getDown() - self._scene:getHeight()
			local leftMargin = cs:getLeft() - self._cameraPosition
			local rightMargin = cs:getRight() - self._cameraPosition - self._screenWidth
			if upMargin < 0 then
				entity:translate(0, -upMargin)
			elseif downMargin > 0 then
				entity:translate(0, -downMargin)
			end

			if leftMargin < 0 then
				entity:translate(-leftMargin, 0)
			elseif rightMargin > 0 then
				entity:translate(-rightMargin, 0)
			end
		end

	end



	function PlayState:_updateEnemies()

		for i = table.getn(self._enemies), 1, -1 do

			local enemy = self._enemies[i]
			local cs = enemy:getContactShape()
			local actX = math.min(enemy:getActivationPoint(), cs:getLeft())

			if cs:getRight() < self._cameraPosition then
				enemy:delete()
				table.remove(self._enemies, i)
			elseif actX - self._cameraPosition < self._screenWidth then
				enemy:setUpdating(true)
			end

		end

	end



	function PlayState:_updateBullets()
		for i = table.getn(self._bullets), 1, -1 do
			local bullet = self._bullets[i]
			local cs = bullet:getContactShape()

			if cs:getRight() < self._cameraPosition or
				-- tapullo
				cs:getLeft() - 32 > self._cameraPosition + self._screenWidth or
				cs:getDown() < 0 or
				cs:getUp() > self._scene:getHeight() then

				bullet:delete()
				table.remove(self._bullets, i)

			end

		end
	end



	function PlayState:_destroyHero()
		if self._hero:isShielded() then
			self._hero:deactivateShield()
		else
			self._hero:die()
			if self._lives <= 0 then
				app.push(LoseState(self._score))
			else
				self:modifyLives(-1)
				self._restartLevel = true
			end
		end
	end



	function PlayState:_destroyEnemy(i)
		self:modifyScore(self._enemies[i]:getScore())
		self._enemies[i]:die();
		table.remove(self._enemies, i)
	end



	function PlayState:_destroyBullet(i)
		self._bullets[i]:die();
		table.remove(self._bullets, i)
	end


	function PlayState:_destroyPowerup(i)
		self._powerups[i]:consume(self._hero, self)
		table.remove(self._powerups, i)
	end



	function PlayState:_checkContacts()
		local hero = self._hero

		if not hero:isDeleted() and not self._godmode then

			for i = table.getn(self._enemies), 1, -1 do
				local enemy = self._enemies[i]
				if obj.checkContact(hero:getContactShape(), enemy:getContactShape()) then
					enemy:resolveCollision(self._hero, self, i)
				end
			end

			if not hero:isInvulnerable() then
				-- Contact between player and bullets
				for i = table.getn(self._bullets), 1, -1 do
					local bullet = self._bullets[i]
					if obj.checkContact(hero:getContactShape(), bullet:getContactShape()) then
						if not hero:isInvincible() then
							self:_destroyHero()
						end
						self:_destroyBullet(i)
					end
				end

			end

		end
	end



	function PlayState:addBullet(bullet)
		table.insert(self._bullets, bullet)
		self._scene:attachChild(bullet)
	end



	function PlayState:modifyLives(amount)
		self._lives = self._lives + amount
	end



	function PlayState:modifyScore(amount)
		self._lifeScore = self._lifeScore + amount
		if self._lifeScore >= self._scoreForLife then
			self._lifeScore = self._lifeScore - self._scoreForLife
			self:modifyLives(1)
			self._lifeUpSound:play()
		end
		self._score = self._score + amount
	end



	function PlayState:startLevel(levelNum)

		local level = lev.levels[levelNum]

		self._worldWidth = lev.levels[levelNum].width
		self._scene:setWidth(self._worldWidth)
		self._endPosition = lev.levels[levelNum].width - self._screenWidth

		self._cameraPosition = 0


		self:clearHero()

		self:clearEnemies()
		self._enemies = class.clone(level.enemies)
		for _, enemy in ipairs(self._enemies) do
			enemy:setWorld(self)
			self._scene:attachChild(enemy)
		end

		self._music:stop()

		-- self:clearPowerUps()
		-- self._powerups = class.clone(level.powerups)
		-- for _, powerup in ipairs(self._powerups) do
		-- 	self._scene:attachChild(powerup)
		-- end

		self:clearBullets()
		self._bullets = {}

	end


	function PlayState:clearHero()
		self._hero:delete()
		self._scene:removeDeletedChildren()
		self._hero:setPosition(self._playerBasePosition)
		self._hero:setShape('human')
		self._hero:undelete()
		self._scene:attachChild(self._hero)
	end


	function PlayState:clearEnemies()
		for i = table.getn(self._enemies), 1, -1 do
			self._enemies[i]:delete()
			table.remove(self._enemies, i)
		end
		self._scene:removeDeletedChildren()
	end



	function PlayState:clearBullets()
		for i = table.getn(self._bullets), 1, -1 do
			self._bullets[i]:delete()
			table.remove(self._bullets, i)
		end
		self._scene:removeDeletedChildren()
	end



	function PlayState:clearPowerUps()
		for i = table.getn(self._powerups), 1, -1 do
			self._powerups[i]:delete()
			table.remove(self._powerups, i)
		end
		self._scene:removeDeletedChildren()
	end



	function PlayState:checkVictory()
		if self._cameraPosition >= self._endPosition then
			self._currentLevel = self._currentLevel + 1
			if self._currentLevel > table.getn(lev.levels) then
				self._music:stop()
				app.push(GameCompleted(self._score))
			else
				self._music:stop()
				app.push(LevelCompleted())
				self:startLevel(self._currentLevel)
			end
		end
	end

end