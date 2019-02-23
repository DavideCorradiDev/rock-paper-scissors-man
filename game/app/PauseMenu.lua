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

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end

	PauseMenu = class.declare(filename, app.State)

	local SCREENW = 16 * 18
	local SCREENH = 16 * 13.5

	function PauseMenu:new(music) 

		app.State.new(self)

		local btnW = 96
		local btnH = 32
		local basePos = 64

		self.sceneRoot = gui.Container{
			origin = hmt.Vector2(btnW/2 + 10, 0),
			position = hmt.Vector2(SCREENW/2, btnH),
			selectable = false,
			visual = gui.Container.Rectangle{
				width = btnW + 20,
				height = btnH * 2 + 20
			}
		}

		

		local buttonVisual = gui.Button.Rectangle{
			width = btnW,
			height = btnH,
		}
		local buttonOrigin = hmt.Vector2(btnW/2, btnH/2)

		self.sceneRoot:attachChild(
			gui.Button{
				origin = buttonOrigin,
				position = hmt.Vector2(10 + btnW/2, btnH / 2 + 10),
				callback = function()
					self:resumeGame()
				end,
				visual = buttonVisual
			}
		)

		self.sceneRoot:attachChild(
			gui.Button{
				origin = buttonOrigin,
				position = hmt.Vector2(10 + btnW/2, btnH + btnH / 2 + 10),
				callback = function()
					app.clear()
					app.push(MainMenu())
				end,
				visual = buttonVisual
			}
		)

		self.sceneRoot:setAsRoot()
		self.sceneRoot:select()

		self.btn1Text = res.Text{
			font = love.graphics.newFont(14),
			string = 'RESUME',
			position = hmt.Vector2(SCREENW/2, btnH + btnH / 2 + 10),
			color = res.Color.Black,
		}
		self.btn1Text:centerOrigin()
		self.btn2Text = res.Text{
			font = love.graphics.newFont(14),
			string = 'MAIN MENU',
			position = hmt.Vector2(SCREENW/2, btnH + btnH + btnH / 2 + 10),
			color = res.Color.Black,
		}
		self.btn2Text:centerOrigin()

		self.music = music

	end


	function PauseMenu:resumeGame()
		app.pop()
		self.music:resume()
	end

	function PauseMenu:update(dt) 

		self.sceneRoot:update(dt)

	end


	function PauseMenu:handleMessage(msg)

		if msg.tag == 'keypressed' then
			if msg.key == 'escape' then
				self:resumeGame()
			end
		elseif msg.tag == 'gamepadpressed' then
			if msg.button == 'start' then
				self:resumeGame()
			end
		end

		self.sceneRoot:handleMessage(msg)

	end


	function PauseMenu:draw() 

		self.sceneRoot:draw()
		self.btn1Text:draw()
		self.btn2Text:draw()

	end

end