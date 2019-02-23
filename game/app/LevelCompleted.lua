-- Copyright (c) 2016 Davide Corradi - All Rights Reserved

local class = require 'hzi.class'
local app = require 'hzi.app'
local gui = require 'hzi.gui'
local hmt = require 'hzi.math'
local scene = require 'hzi.scene'
local res = require 'hzi.resources'
local love = love

local ipairs = ipairs
local print = print

local filename = ...

local SCREENW = 16 * 18
local SCREENH = 16 * 13.5

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end

	LevelCompleted = class.declare(filename, app.State)

	function LevelCompleted:new() 

		app.State.new(self)

		self.text1 = res.Text{
			font = love.graphics.newFont(18),
			string = 'LEVEL COMPLETE!!',
			position = hmt.Vector2(SCREENW/2, 32),
			color = res.Color.white,
		}
		self.text1:centerOrigin()
		self.text2 = res.Text{
			font = love.graphics.newFont(14),
			string = 'Press a key to continue',
			position = hmt.Vector2(SCREENW/2, 96),
			color = res.Color.white,
		}
		self.text2:centerOrigin()

	end


	function LevelCompleted:update(dt) end


	function LevelCompleted:handleMessage(msg) 

		if msg.tag == 'keypressed' or msg.tag == 'gamepadpressed' then
			app.pop()
		end

	end


	function LevelCompleted:draw() 

		self.text1:draw()
		self.text2:draw()

	end

end