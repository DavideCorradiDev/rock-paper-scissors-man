-- Copyright (c) 2016 Davide Corradi - All rights reserved.

local require = require
local obj = require 'game.objects'

local table = table
local math = math

local P = {}
local namespace = ...
if setfenv then setfenv(1, P) else _ENV = P end

local SCREENW = 288
local SCREENH = 16 * 12


local function insertEnemyFixedRow(level, posX, posY, offsetX, offsetY, types, weapons)
	local ev = level.enemies
	local ap = math.min(posX - 8, posX + table.getn(types) * offsetX - 8)
	for i = 1, table.getn(types) do
		local x = posX + offsetX * (i-1)
		local y = posY + offsetY * (i-1)
		local enemy = obj.createEnemy(types[i], x, y, {}, weapons[i], ap)
		table.insert(ev, enemy)
	end
end

local function insertEnemyRow(level, posX, posY, offsetY, types, weapons)

	local ev = level.enemies
	for i = 1, table.getn(types) do
		local y = posY + offsetY * (i-1)
		table.insert(ev, obj.createEnemy(types[i], posX, y, obj.pathHorizontal(y), weapons[i], posX - 8))
	end

end


local function insertEnemySkewRow(level, posX, posY, offsetX, offsetY, types, weapons)

	local ev = level.enemies
	local ap = math.min(posX - 8, posX + table.getn(types) * offsetX - 8)
	for i = 1, table.getn(types) do
		local x = posX + offsetX * (i-1)
		local y = posY + offsetY * (i-1)
		local enemy = obj.createEnemy(types[i], x, y, obj.pathHorizontal(y), weapons[i], ap)
		table.insert(ev, enemy)
	end

end


local function insertUpDownRow(level, posX, posY, offsetX, offsetY, moveY, types, weapons, actOffset)

	actOffset = actOffset or 0
	local ev = level.enemies
	local ap = math.min(posX - 8, posX + table.getn(types) * offsetX - 8) + actOffset
	for i = 1, table.getn(types) do
		local x = posX + offsetX * (i-1)
		local y = posY + offsetY * (i-1)
		local enemy = obj.createEnemy(types[i], x, y, obj.pathUpDown(x, y, moveY), weapons[i], ap, true)
		table.insert(ev, enemy)
	end

end

local function insertDeathDoor(level, posX, posY, offsetX, offsetY, types1, weapons1, types2, weapons2)

	local endPos = SCREENH - posY - offsetY * table.getn(types2)
	insertUpDownRow(level, posX, posY, offsetX, offsetY, endPos, types1, weapons1)
	insertUpDownRow(level, posX, posY + endPos, offsetX, offsetY, -endPos, types2, weapons2)

end

local function insertEnemySnake(level, posX, posY, offsetX, offsetY, moveX, moveY, types, weapons)

	local ev = level.enemies
	local ap = math.min(posX - 8, posX + table.getn(types) * offsetX - 8)
	for i = 1, table.getn(types) do
		local x = posX + offsetX * (i-1)
		local y = posY + offsetY * (i-1)
		local enemy = obj.createEnemy(types[i], x, y, obj.pathLxyx(x, y, moveX, moveY), weapons[i], ap)
		table.insert(ev, enemy)
	end

end


levels = {}

levels[1] = {
	
	width = SCREENW * 21,

	enemies = {},

}

-- insertEnemySkewRow(levels[1], SCREENW * 2 - 32, 32, 0, 64
-- 	, {'points', 'points', 'points'}
-- 	, {'none', 'none', 'none'})
-- insertEnemySkewRow(levels[1], SCREENW * 2, 32, 0, 64
-- 	, {'shield', 'shield', 'shield'}
-- 	, {'none', 'none', 'none'})
-- insertEnemySkewRow(levels[1], SCREENW * 2 + 32, 32, 0, 64
-- 	, {'life', 'life', 'life'}
-- 	, {'none', 'none', 'none'})
-- insertEnemySkewRow(levels[1], SCREENW * 2 + 64, 32, 0, 64
-- 	, {'invincibility', 'invincibility', 'invincibility'}
-- 	, {'none', 'none', 'none'})

insertEnemySkewRow(levels[1], SCREENW * 2, 32, 0, 64
	, {'rock', 'rock', 'rock'}
	, {'none', 'none', 'none'})
insertEnemySkewRow(levels[1], SCREENW * 2 + 32, 32, 0, 64
	, {'rock', 'rock', 'rock'}
	, {'none', 'none', 'none'})
insertEnemySkewRow(levels[1], SCREENW * 2.5, 32, 0, 64
	, {'paper', 'paper', 'paper'}
	, {'none', 'none', 'none'})
insertEnemySkewRow(levels[1], SCREENW * 2.5 + 32, 32, 0, 64
	, {'paper', 'paper', 'paper'}
	, {'none', 'none', 'none'})
insertEnemySkewRow(levels[1], SCREENW * 3, 32, 0, 64
	, {'scissors', 'scissors', 'scissors'}
	, {'none', 'none', 'none'})
insertEnemySkewRow(levels[1], SCREENW * 3 + 32, 32, 0, 64
	, {'scissors', 'scissors', 'scissors'}
	, {'none', 'none', 'none'})
insertEnemySkewRow(levels[1], SCREENW * 3.5, 32, 0, 64
	, {'bomb', 'bomb', 'bomb'}
	, {'none', 'none', 'none'})
insertEnemySkewRow(levels[1], SCREENW * 3.5 + 32, 32, 0, 64
	, {'bomb', 'bomb', 'bomb'}
	, {'none', 'none', 'none'})
insertEnemySkewRow(levels[1], SCREENW * 4, 32, 0, 64
	, {'points', 'points', 'points'}
	, {'none', 'none', 'none'})
insertEnemySkewRow(levels[1], SCREENW * 4 + 32, 32, 0, 64
	, {'points', 'points', 'points'}
	, {'none', 'none', 'none'})

insertDeathDoor(levels[1], SCREENW * 4.5, 32, 0, 32
	, {'rock'}, {'none'}, {'scissors'}, {'none'})
insertDeathDoor(levels[1], SCREENW * 5, 32, 0, 32
	, {'scissors'}, {'none'}, {'paper'}, {'none'})
insertDeathDoor(levels[1], SCREENW * 5.5, 32, 0, 32
	, {'paper'}, {'none'}, {'rock'}, {'none'})
insertDeathDoor(levels[1], SCREENW * 6, 32, 0, 32
	, {'bomb'}, {'none'}, {'bomb'}, {'none'})

insertEnemySkewRow(levels[1], SCREENW * 6.5, 32, 32, 0
	, {'rock', 'rock', 'rock'}
	, {'none', 'none', 'none'})
insertEnemySkewRow(levels[1], SCREENW * 6.5 + 32, 96, 32, 0
	, {'paper', 'paper', 'paper'}
	, {'none', 'none', 'none'})
insertEnemySkewRow(levels[1], SCREENW * 6.5 + 64, 160, 32, 0
	, {'scissors', 'scissors', 'scissors'}
	, {'none', 'none', 'none'})

insertEnemySkewRow(levels[1], SCREENW * 7, 32, 32, 0
	, {'scissors', 'scissors', 'scissors'}
	, {'none', 'none', 'none'})
insertEnemySkewRow(levels[1], SCREENW * 7 + 32, 96, 32, 0
	, {'rock', 'rock', 'rock'}
	, {'none', 'none', 'none'})
insertEnemySkewRow(levels[1], SCREENW * 7 + 64, 160, 32, 0
	, {'paper', 'paper', 'paper'}
	, {'none', 'none', 'none'})

insertEnemySkewRow(levels[1], SCREENW * 7.5, 32, 32, 0
	, {'bomb', 'bomb', 'bomb'}
	, {'none', 'none', 'none'})
insertEnemySkewRow(levels[1], SCREENW * 7.5 + 32, 96, 32, 0
	, {'bomb', 'bomb', 'bomb'}
	, {'none', 'none', 'none'})
insertEnemySkewRow(levels[1], SCREENW * 7.5 + 64, 160, 32, 0
	, {'bomb', 'bomb', 'bomb'}
	, {'none', 'none', 'none'})

insertEnemySkewRow(levels[1], SCREENW * 8, 32, 32, 0
	, {'points', 'points', 'points'}
	, {'none', 'none', 'none'})
insertEnemySkewRow(levels[1], SCREENW * 8 + 32, 96, 32, 0
	, {'points', 'points', 'points'}
	, {'none', 'none', 'none'})
insertEnemySkewRow(levels[1], SCREENW * 8 + 64, 160, 32, 0
	, {'points', 'points', 'points'}
	, {'none', 'none', 'none'})

insertEnemySkewRow(levels[1], SCREENW * 8.5, 32, 32, 0
	, {'bomb', 'bomb', 'bomb'}
	, {'none', 'none', 'none'})
insertEnemySkewRow(levels[1], SCREENW * 8.5 + 32, 96, 32, 0
	, {'bomb', 'bomb', 'bomb'}
	, {'none', 'none', 'none'})
insertEnemySkewRow(levels[1], SCREENW * 8.5 + 64, 160, 32, 0
	, {'bomb', 'bomb', 'bomb'}
	, {'none', 'none', 'none'})

insertEnemySkewRow(levels[1], SCREENW * 9, 32, 0, 64
	, {'points', 'shield', 'points'}
	, {'none'})

insertEnemySkewRow(levels[1], SCREENW * 9.5, 32, 0, 64
	, {'rock', 'rock', 'rock'}
	, {'forwardGun', 'forwardGun', 'forwardGun'})
insertEnemySkewRow(levels[1], SCREENW * 10, 32, 0, 64
	, {'paper', 'paper', 'paper'}
	, {'forwardGun', 'forwardGun', 'forwardGun'})
insertEnemySkewRow(levels[1], SCREENW * 10.5, 32, 0, 64
	, {'scissors', 'scissors', 'scissors'}
	, {'forwardGun', 'forwardGun', 'forwardGun'})
insertEnemySkewRow(levels[1], SCREENW * 11, 32, 0, 64
	, {'bomb', 'bomb', 'bomb'}
	, {'forwardGun', 'forwardGun', 'forwardGun'})

insertEnemySkewRow(levels[1], SCREENW * 11.5, 64, 0, 32
	, {'rock', 'rock', 'rock'}
	, {'none', 'none', 'none'})
insertEnemySkewRow(levels[1], SCREENW * 11.5 + 32, 64, 0, 32
	, {'rock', 'life', 'rock'}
	, {'none', 'none', 'none'})
insertEnemySkewRow(levels[1], SCREENW * 11.5 + 64, 64, 0, 32
	, {'rock', 'rock', 'rock'}
	, {'none', 'none', 'none'})

insertUpDownRow(levels[1], SCREENW * 12, 32, 32, 32, SCREENH - 96
	, {'rock', 'paper'}
	, {'forwardGun', 'forwardGun'})
insertUpDownRow(levels[1], SCREENW * 12.5, SCREENH - 32, 32, -32, -(SCREENH - 96)
	, {'paper', 'rock'}
	, {'forwardGun', 'forwardGun'})
insertUpDownRow(levels[1], SCREENW * 13, 32, 32, 32, SCREENH - 96
	, {'scissors', 'rock'}
	, {'forwardGun', 'forwardGun'})
insertUpDownRow(levels[1], SCREENW * 13.5, SCREENH - 32, 32, -32, -(SCREENH - 96)
	, {'rock', 'scissors'}
	, {'forwardGun', 'forwardGun'})
insertUpDownRow(levels[1], SCREENW * 14, 32, 32, 32, SCREENH - 96
	, {'paper', 'scissors'}
	, {'forwardGun', 'forwardGun'})
insertUpDownRow(levels[1], SCREENW * 14.5, SCREENH - 32, 32, -32, -(SCREENH - 96)
	, {'scissors', 'paper'}
	, {'forwardGun', 'forwardGun'})
insertUpDownRow(levels[1], SCREENW * 15, 32, 32, 32, SCREENH - 96
	, {'points', 'points'}
	, {'none', 'none'})
insertUpDownRow(levels[1], SCREENW * 15.5, SCREENH - 32, 32, -32, -(SCREENH - 96)
	, {'points', 'points'}
	, {'none', 'none'})

insertUpDownRow(levels[1], SCREENW * 16, 32, 0, 0, (SCREENH - 32)
	, {'invincibility'}
	, {'none'})
insertUpDownRow(levels[1], SCREENW * 16.5, SCREENH - 32, 0, 0, -(SCREENH - 32)
	, {'bomb'}
	, {'tripleGun'})

insertEnemySkewRow(levels[1], SCREENW * 17, 16, 0, 32
	, {'rock', 'rock', 'rock','rock', 'rock', 'rock'}
	, {'none', 'none', 'none', 'none', 'none', 'none'})
insertEnemySkewRow(levels[1], SCREENW * 17 + 32, 16, 0, 32
	, {'rock', 'rock', 'rock','rock', 'rock', 'rock'}
	, {'none', 'none', 'none', 'none', 'none', 'none'})
insertEnemySkewRow(levels[1], SCREENW * 17.5, 16, 0, 32
	, {'paper', 'paper', 'paper','paper', 'paper', 'paper'}
	, {'none', 'none', 'none', 'none', 'none', 'none'})
insertEnemySkewRow(levels[1], SCREENW * 17.5 + 32, 16, 0, 32
	, {'paper', 'paper', 'paper','paper', 'paper', 'paper'}
	, {'none', 'none', 'none', 'none', 'none', 'none'})
insertEnemySkewRow(levels[1], SCREENW * 18, 16, 0, 32
	, {'scissors', 'scissors', 'scissors', 'scissors', 'scissors', 'scissors'}
	, {'none', 'none', 'none', 'none', 'none', 'none'})
insertEnemySkewRow(levels[1], SCREENW * 18 + 32, 16, 0, 32
	, {'scissors', 'scissors', 'scissors', 'scissors', 'scissors', 'scissors'}
	, {'none', 'none', 'none', 'none', 'none', 'none'})
insertEnemySkewRow(levels[1], SCREENW * 18.5, 16, 0, 32
	, {'bomb', 'paper', 'bomb', 'bomb', 'paper', 'bomb'}
	, {'none', 'none', 'none', 'none', 'none', 'none'})
insertEnemySkewRow(levels[1], SCREENW * 18.5 + 32, 16, 0, 32
	, {'bomb', 'rock', 'bomb', 'bomb', 'rock', 'bomb'}
	, {'none', 'none', 'none', 'none', 'none', 'none'})
insertEnemySkewRow(levels[1], SCREENW * 19, 16, 0, 32
	, {'points', 'points', 'points', 'points', 'points', 'points'}
	, {'none', 'none', 'none', 'none', 'none', 'none'})
insertEnemySkewRow(levels[1], SCREENW * 19 + 32, 16, 0, 32
	, {'points', 'points', 'points', 'points', 'points', 'points'}
	, {'none', 'none', 'none', 'none', 'none', 'none'})


levels[2] = {
	
	width = SCREENW * 22,

	enemies = {},

}

insertEnemySnake(levels[2], SCREENW * 2, 32, 16, 0, -64, 48
	, {'rock', 'rock', 'rock'}
	, {'none', 'none', 'none'})
insertEnemySnake(levels[2], SCREENW * 2, SCREENH - 32, 16, 0, -64, -48
	, {'rock', 'rock', 'rock'}
	, {'none', 'none', 'none'})
insertEnemyFixedRow(levels[2], SCREENW * 2, SCREENH / 2, 32, 0
	, {'points', 'points'}
	, {'none', 'none'})

insertEnemySnake(levels[2], SCREENW * 2.5, 32, 16, 0, -64, 48
	, {'paper', 'paper', 'paper'}
	, {'none', 'none', 'none'})
insertEnemySnake(levels[2], SCREENW * 2.5, SCREENH - 32, 16, 0, -64, -48
	, {'paper', 'paper', 'paper'}
	, {'none', 'none', 'none'})
insertEnemyFixedRow(levels[2], SCREENW * 2.5, SCREENH / 2, 32, 0
	, {'points', 'points'}
	, {'none', 'none'})

insertEnemySnake(levels[2], SCREENW * 3, 32, 16, 0, -64, 48
	, {'scissors', 'scissors', 'scissors'}
	, {'none', 'none', 'none'})
insertEnemySnake(levels[2], SCREENW * 3, SCREENH - 32, 16, 0, -64, -48
	, {'scissors', 'scissors', 'scissors'}
	, {'none', 'none', 'none'})
insertEnemyFixedRow(levels[2], SCREENW * 3, SCREENH / 2, 32, 0
	, {'points', 'points'}
	, {'none', 'none'})

insertEnemyFixedRow(levels[2], SCREENW * 3.5, 48, 0, 16
	, {'rock', 'points', 'paper', 'points', 'scissors', 'points', 'rock'}
	, {'forwardGun', 'none', 'forwardGun', 'none', 'forwardGun', 'none', 'forwardGun'})

insertEnemySkewRow(levels[2], SCREENW * 4, SCREENH/2 - 48, 32, 0
	, {'rock', 'scissors', 'paper','points'}
	, {'none', 'none', 'none', 'none', 'none', 'none'})
insertEnemySkewRow(levels[2], SCREENW * 4, SCREENH/2, 32, 0
	, {'rock', 'scissors', 'paper','points'}
	, {'none', 'none', 'none', 'none', 'none', 'none'})
insertEnemySkewRow(levels[2], SCREENW * 4, SCREENH/2 + 48, 32, 0
	, {'rock', 'scissors', 'paper','points'}
	, {'none', 'none', 'none', 'none', 'none', 'none'})

local endPos = SCREENH - 32
insertUpDownRow(levels[2], SCREENW * 4.5, 32, 32, 0, endPos
	, {'rock', 'rock', 'rock', 'rock'}
	, {'none', 'none', 'none', 'none'})
insertUpDownRow(levels[2], SCREENW * 4.5 + 16, endPos, 32, 0, -endPos
	, {'scissors', 'scissors', 'scissors', 'scissors'}
	, {'none', 'none', 'none', 'none'}, 16)
insertEnemyFixedRow(levels[2], SCREENW * 4.5, SCREENH / 2, 32, 0
	, {'points', 'points', 'points', 'points'}
	, {'none', 'none', 'none', 'none'})


insertEnemySkewRow(levels[2], SCREENW* 6, 64, 0, 0
	, {'bomb'}, {'crossGun'})
insertEnemySkewRow(levels[2], SCREENW* 6, SCREENH - 64, 0, 0
	, {'bomb'}, {'crossGun'})
insertEnemySkewRow(levels[2], SCREENW* 6, SCREENH/2, 0, 0
	, {'shield'}, {'none'})


insertEnemySnake(levels[2], SCREENW * 6.5, SCREENH / 2 - 16, 16, 0, -64, -48
	, {'rock', 'rock', 'rock'}
	, {'forwardGun', 'none', 'none'})
insertEnemySnake(levels[2], SCREENW * 6.5, SCREENH / 2 + 16, 16, 0, -64, 48
	, {'rock', 'rock', 'rock'}
	, {'forwardGun', 'none', 'none'})
insertEnemyFixedRow(levels[2], SCREENW * 6.5, SCREENH / 2, 32, 0
	, {'points', 'points'}
	, {'none', 'none'})

insertEnemySnake(levels[2], SCREENW * 7, SCREENH / 2 - 16, 16, 0, -64, -48
	, {'paper', 'paper', 'paper'}
	, {'forwardGun', 'none', 'none'})
insertEnemySnake(levels[2], SCREENW * 7, SCREENH / 2 + 16, 16, 0, -64, 48
	, {'paper', 'paper', 'paper'}
	, {'forwardGun', 'none', 'none'})
insertEnemyFixedRow(levels[2], SCREENW * 7, SCREENH / 2, 32, 0
	, {'points', 'points'}
	, {'none', 'none'})

insertEnemySnake(levels[2], SCREENW * 7.5, SCREENH / 2 - 16, 16, 0, -64, -48
	, {'scissors', 'scissors', 'scissors'}
	, {'forwardGun', 'none', 'none'})
insertEnemySnake(levels[2], SCREENW * 7.5, SCREENH / 2 + 16, 16, 0, -64, 48
	, {'scissors', 'scissors', 'scissors'}
	, {'forwardGun', 'none', 'none'})
insertEnemyFixedRow(levels[2], SCREENW * 7.5, SCREENH / 2, 32, 0
	, {'points', 'points'}
	, {'none', 'none'})

insertEnemyFixedRow(levels[2], SCREENW * 8, 32, 32, 0
	, {'bomb', 'bomb', 'bomb', 'bomb', 'bomb'}
	, {'none', 'none', 'crossGun', 'none', 'none'})
insertEnemyFixedRow(levels[2], SCREENW * 8 + 16, 96, 32, 0
	, {'bomb', 'bomb', 'bomb', 'bomb', 'bomb'}
	, {'none', 'none', 'crossGun', 'none', 'none'})
insertEnemyFixedRow(levels[2], SCREENW * 8, 162, 32, 0
	, {'bomb', 'bomb', 'bomb', 'bomb', 'bomb'}
	, {'none', 'none', 'crossGun', 'none', 'none'})

insertEnemySnake(levels[2], SCREENW * 9.5, SCREENH / 2 - 16, 16, 0, -64, -48
	, {'scissors', 'scissors', 'scissors', 'scissors'}
	, {'none', 'none', 'none', 'none'})
insertEnemySnake(levels[2], SCREENW * 9.5, SCREENH / 2 + 16, 16, 0, -64, 48
	, {'scissors', 'scissors', 'scissors', 'scissors'}
	, {'none', 'none', 'none', 'none'})
insertEnemySnake(levels[2], SCREENW * 9.5, 32, 16, 0, -64, 48
	, {'rock', 'rock', 'rock', 'rock'}
	, {'none', 'none', 'none', 'none'})
insertEnemySnake(levels[2], SCREENW * 9.5, SCREENH - 32, 16, 0, -64, -48
	, {'rock', 'rock', 'rock', 'rock'}
	, {'none', 'none', 'none', 'none'})
insertUpDownRow(levels[2], SCREENW * 9.5, 32, 32, 0, SCREENH - 32
	, {'points', 'points', 'points', 'points'}
	, {'none', 'none', 'none', 'none'})

insertEnemyFixedRow(levels[2], SCREENW * 10, SCREENH/2 - 16, 16, 0
	, {'rock', 'scissors', 'paper'}
	, {'none', 'none', 'none'})
insertEnemyFixedRow(levels[2], SCREENW * 10, SCREENH/2, 16, 0
	, {'rock', 'life', 'scissors'}
	, {'none', 'none', 'none'})
insertEnemyFixedRow(levels[2], SCREENW * 10, SCREENH/2 + 16, 16, 0
	, {'rock', 'scissors', 'paper'}
	, {'none', 'none', 'none'})

insertDeathDoor(levels[2], SCREENW * 10.5, 32, 0, 32
	, {'rock'}, {'forwardGun'}, {'scissors'}, {'forwardGun'})
insertDeathDoor(levels[2], SCREENW * 11, 32, 0, 32
	, {'scissors'}, {'forwardGun'}, {'paper'}, {'forwardGun'})
insertDeathDoor(levels[2], SCREENW * 11.5, 32, 0, 32
	, {'paper'}, {'forwardGun'}, {'rock'}, {'forwardGun'})
insertDeathDoor(levels[2], SCREENW * 12, 32, 0, 32
	, {'bomb'}, {'forwardGun'}, {'bomb'}, {'forwardGun'})

insertDeathDoor(levels[2], SCREENW * 12.5, 64, 0, 32
	, {'bomb'}, {'forwardGun'}, {'bomb'}, {'forwardGun'})
insertEnemyFixedRow(levels[2], SCREENW * 12.5 + 32, SCREENH/2, 0, 0
	, {'invincibility'}
	, {'none'})
insertDeathDoor(levels[2], SCREENW * 12.5 + 64, 64, 0, 32
	, {'bomb'}, {'forwardGun'}, {'bomb'}, {'forwardGun'})

insertEnemyFixedRow(levels[2], SCREENW * 13, 32, 32, 0
	, {'rock', 'scissors', 'paper', 'points', 'rock'}
	, {'none', 'none', 'none', 'none', 'none'})
insertEnemyFixedRow(levels[2], SCREENW * 13, 64, 32, 0
	, {'rock', 'rock', 'scissors', 'paper', 'points'}
	, {'none', 'none', 'none', 'none', 'none'})
insertEnemyFixedRow(levels[2], SCREENW * 13, 96, 32, 0
	, {'points', 'rock', 'rock', 'scissors', 'paper'}
	, {'none', 'none', 'none', 'none', 'none'})
insertEnemyFixedRow(levels[2], SCREENW * 13, 128, 32, 0
	, {'paper', 'points', 'rock', 'rock', 'scissors'}
	, {'none', 'none', 'none', 'none', 'none'})
insertEnemyFixedRow(levels[2], SCREENW * 13, 160, 32, 0
	, {'scissors', 'paper', 'points', 'rock', 'rock'}
	, {'none', 'none', 'none', 'none', 'none'})

insertEnemySkewRow(levels[2], SCREENW * 14, 32, 0, 64
	, {'rock', 'rock', 'rock'}
	, {'forwardGun', 'none', 'none'})
insertEnemySkewRow(levels[2], SCREENW * 14.5, 32, 0, 64
	, {'paper', 'paper', 'paper'}
	, {'forwardGun', 'none', 'none'})
insertEnemySkewRow(levels[2], SCREENW * 15, 32, 0, 64
	, {'scissors', 'scissors', 'scissors'}
	, {'forwardGun', 'forwardGun', 'forwardGun'})


insertEnemySnake(levels[2], SCREENW * 15.5, 32, 16, 0, -64, 48
	, {'rock', 'scissors', 'paper'}
	, {'none', 'none', 'none'})
insertEnemySnake(levels[2], SCREENW * 15.5, SCREENH - 32, 16, 0, -64, -48
	, {'rock', 'scissors', 'paper'}
	, {'none', 'none', 'none'})
insertEnemyFixedRow(levels[2], SCREENW * 15.5, SCREENH / 2, 32, 0
	, {'bomb', 'points', 'bomb'}
	, {'none', 'none', 'bomb'})

insertEnemySnake(levels[2], SCREENW * 16, 32, 16, 0, -64, 48
	, {'scissors', 'rock', 'paper'}
	, {'none', 'none', 'none'})
insertEnemySnake(levels[2], SCREENW * 16, SCREENH - 32, 16, 0, -64, -48
	, {'scissors', 'rock', 'paper'}
	, {'none', 'none', 'none'})
insertEnemyFixedRow(levels[2], SCREENW * 16, SCREENH / 2, 32, 0
	, {'bomb', 'points', 'bomb'}
	, {'none', 'none', 'bomb'})

insertEnemySnake(levels[2], SCREENW * 16.5, 32, 16, 0, -64, 48
	, {'paper', 'rock', 'scissors'}
	, {'none', 'none', 'none'})
insertEnemySnake(levels[2], SCREENW * 16.5, SCREENH - 32, 16, 0, -64, -48
	, {'paper', 'rock', 'scissors'}
	, {'none', 'none', 'none'})
insertEnemyFixedRow(levels[2], SCREENW * 16.5, SCREENH / 2, 32, 0
	, {'bomb', 'points', 'bomb'}
	, {'none', 'none', 'bomb'})

insertEnemyFixedRow(levels[2], SCREENW * 17, 32, 32, 0
	, {'rock', 'scissors', 'paper', 'points', 'rock'}
	, {'forwardGun', 'none', 'none', 'none', 'none'})
insertEnemyFixedRow(levels[2], SCREENW * 17, 64, 32, 0
	, {'rock', 'rock', 'scissors', 'paper', 'points'}
	, {'none', 'none', 'none', 'none', 'none'})
insertEnemyFixedRow(levels[2], SCREENW * 17, 96, 32, 0
	, {'points', 'rock', 'rock', 'scissors', 'paper'}
	, {'none', 'none', 'none', 'none', 'tripleGun'})
insertEnemyFixedRow(levels[2], SCREENW * 17, 128, 32, 0
	, {'paper', 'points', 'rock', 'rock', 'scissors'}
	, {'none', 'none', 'none', 'none', 'none'})
insertEnemyFixedRow(levels[2], SCREENW * 17, 160, 32, 0
	, {'scissors', 'paper', 'points', 'rock', 'rock'}
	, {'forwardGun', 'none', 'none', 'none', 'none'})

insertDeathDoor(levels[2], SCREENW * 18, 32, 0, 32
	, {'rock'}, {'tripleGun'}, {'scissors'}, {'tripleGun'})
insertDeathDoor(levels[2], SCREENW * 18.5, 32, 0, 32
	, {'scissors'}, {'tripleGun'}, {'paper'}, {'tripleGun'})
insertDeathDoor(levels[2], SCREENW * 19, 32, 0, 32
	, {'paper'}, {'tripleGun'}, {'rock'}, {'tripleGun'})
insertDeathDoor(levels[2], SCREENW * 19.5, 32, 0, 32
	, {'bomb'}, {'tripleGun'}, {'bomb'}, {'tripleGun'})


return P