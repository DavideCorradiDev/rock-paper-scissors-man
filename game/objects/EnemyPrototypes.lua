-- Copyright (c) 2016 Davide Corradi - All Rights Reserved

local class = require 'hzi.class'
local res = require 'hzi.resources'
local hmt = require 'hzi.math'
local love = love

local print = print

local filename = ...

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end

	local ENEMY_RADIUS = 8
	local ENEMY_SPEED = 64
	local ENEMY_RELOAD_TIME = 1
	local ENEMY_BULLET_SPEED = 128

	local deathSounds = {
		rock = res.sound.rockDeath,
		paper = res.sound.paperDeath,
		scissors = res.sound.scissorsDeath,
		bomb = res.sound.bombDeath,
		points = res.sound.pointsPU,
		invincibility = res.sound.invincibilityPU,
		life = res.sound.lifePU,
		shield = res.sound.shieldPU,
	}

	function createEnemy(type, x, y, wp, weaponType, activationPoint, loop)

		local enemy = Enemy{

			updating = false,

			position = hmt.Vector2(x, y),
			origin = hmt.Vector2(ENEMY_RADIUS, ENEMY_RADIUS),
			image = res.image.enemy,
			weaponImage = res.image.bullet,

			shootSound = res.sound.shoot,
			deathSound = deathSounds[type],

			contactShape = CircleContact{
				origin = hmt.Vector2(ENEMY_RADIUS-2, ENEMY_RADIUS-2),
				radius = ENEMY_RADIUS,
			},

			type = type,
			speed = ENEMY_SPEED,
			waypoints = wp,
			activationPoint = activationPoint,
			loopPath = loop,
		}


		if weaponType == 'forwardGun' then
			enemy:addWeapon{
				rotation = 0,
				reloadTime = ENEMY_RELOAD_TIME,
				bulletSpeed = ENEMY_BULLET_SPEED
			}
		elseif weaponType == 'tripleGun' then
			enemy:addWeapon{
				rotation = 0,
				reloadTime = ENEMY_RELOAD_TIME,
				bulletSpeed = ENEMY_BULLET_SPEED
			}
			enemy:addWeapon{
				rotation = 45,
				reloadTime = ENEMY_RELOAD_TIME,
				bulletSpeed = ENEMY_BULLET_SPEED
			}
			enemy:addWeapon{
				rotation = -45,
				reloadTime = ENEMY_RELOAD_TIME,
				bulletSpeed = ENEMY_BULLET_SPEED
			}
		elseif weaponType == 'crossGun' then
			enemy:addWeapon{
				rotation = 0,
				reloadTime = ENEMY_RELOAD_TIME,
				bulletSpeed = ENEMY_BULLET_SPEED
			}
			enemy:addWeapon{
				rotation = 90,
				reloadTime = ENEMY_RELOAD_TIME,
				bulletSpeed = ENEMY_BULLET_SPEED
			}
			enemy:addWeapon{
				rotation = -90,
				reloadTime = ENEMY_RELOAD_TIME,
				bulletSpeed = ENEMY_BULLET_SPEED
			}
			enemy:addWeapon{
				rotation = 180,
				reloadTime = ENEMY_RELOAD_TIME,
				bulletSpeed = ENEMY_BULLET_SPEED
			}
		end

		return enemy

	end



	function pathHorizontal(posY)

		return { hmt.Vector2(0, posY) }

	end


	function pathLxy(posX, posY, l1, l2)

		return {
			hmt.Vector2(posX + l1, posY),
			hmt.Vector2(posX + l1, posY + l2)
		}

	end


	function pathLxyx(posX, posY, l1, l2)

		return {
			hmt.Vector2(posX + l1, posY),
			hmt.Vector2(posX + l1, posY + l2),
			hmt.Vector2(0, posY + l2),
		}

	end


	function pathUpDown(posX, posY, l)
		return {
			hmt.Vector2(posX, posY+l),
			hmt.Vector2(posX, posY),
		}
	end

end