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

	GameCompleted = class.declare(filename, app.State)

	function GameCompleted:new(score) 

		app.State.new(self)

		self.text1 = res.Text{
			font = love.graphics.newFont(18),
			string = 'GAME COMPLETE!!',
			position = hmt.Vector2(SCREENW/2, 32),
			color = res.Color.white,
		}
		self.text1:centerOrigin()
		self.text2 = res.Text{
			font = love.graphics.newFont(14),
			string = 'Your score: ' .. score,
			position = hmt.Vector2(SCREENW/2, 96),
			color = res.Color.white,
		}
		self.text2:centerOrigin()
		self.text3 = res.Text{
			font = love.graphics.newFont(14),
			string = 'Press a key to return to the menu',
			position = hmt.Vector2(SCREENW/2, 120),
			color = res.Color.white,
		}
		self.text3:centerOrigin()

	end


	function GameCompleted:update(dt) end


	function GameCompleted:handleMessage(msg) 

		if msg.tag == 'keypressed' or msg.tag == 'gamepadpressed' then
			app.clear()
			app.push(MainMenu())
		end

	end


	function GameCompleted:draw() 

		self.text1:draw()
		self.text2:draw()
		self.text3:draw()

	end

end