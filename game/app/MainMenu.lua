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

	MainMenu = class.declare(filename, app.State)

	local SCREENW = 16 * 18
	local SCREENH = 16 * 13.5

	function MainMenu:new()
		app.State.new(self)

		self.sceneRoot = gui.Container{
			position = hmt.Vector2(SCREENW/2, 112),
			selectable = false,
			visual = gui.Container.Rectangle{
				height = 0,
				width = 0
			}
		}

		local btnW = 96
		local btnH = 32

		local buttonVisual = gui.Button.Rectangle{
			width = btnW,
			height = btnH,
		}
		local buttonOrigin = hmt.Vector2(btnW/2, btnH/2)

		self.sceneRoot:attachChild(
			gui.Button{
				origin = buttonOrigin,
				position = hmt.Vector2(0, 0),
				callback = function()
					app.pop()
					app.push(PlayState())
				end,
				visual = buttonVisual
			}
		)

		self.sceneRoot:attachChild(
			gui.Button{
				origin = buttonOrigin,
				position = hmt.Vector2(0, btnH),
				callback = function()
					app.push(HelpScreen())
				end,
				visual = buttonVisual
			}
		)

		self.sceneRoot:attachChild(
			gui.Button{
				origin = buttonOrigin,
				position = hmt.Vector2(0, btnH * 2),
				callback = function()
					app.pop()
				end,
				visual = buttonVisual
			}
		)

		self.sceneRoot:setAsRoot()
		self.sceneRoot:select()

		self.btn1Text = res.Text{
			font = love.graphics.newFont(14),
			string = 'NEW GAME',
			position = hmt.Vector2(SCREENW/2, 112),
			color = res.Color.Black,
		}
		self.btn1Text:centerOrigin()
		self.btn2Text = res.Text{
			font = love.graphics.newFont(14),
			string = 'HOW TO PLAY',
			position = hmt.Vector2(SCREENW/2, 112 + btnH),
			color = res.Color.Black,
		}
		self.btn2Text:centerOrigin()
		self.btn3Text = res.Text{
			font = love.graphics.newFont(14),
			string = 'QUIT',
			position = hmt.Vector2(SCREENW/2, 112 + btnH * 2),
			color = res.Color.Black,
		}
		self.btn3Text:centerOrigin()

		self.titleText = res.Text{
			font = love.graphics.newFont(18),
			string = 'ROCK-PAPER-SCISSORS MAN!!!',
			position = hmt.Vector2(SCREENW/2, 32),
			color = res.Color.white,
		}
		self.titleText:centerOrigin()

		self._music = res.music.music
		self._music:play()

		res.image.backgroundstars:setWrap('repeat', 'repeat')
		local bgimg = res.image.backgroundstars
		self.bg = res.Sprite{
			image = bgimg,
			rect = hmt.Rect(0, 0, bgimg:getWidth() * 3, bgimg:getHeight())
		}

		self.cameraPos = 0
		self.cameraRestartPos = bgimg:getWidth()
		self.cameraSpeed = 32

		self.heroSprite = res.AnimatedSprite{
			origin = hmt.Vector2(8, 8),
			position = hmt.Vector2(SCREENW/2, 64),
			animation = res.Animation{
				image = res.image.hero,
				frames = {
					hmt.Rect(0, 0, 16, 16),
				},
			},
			duration = 1.,
			looping = true,
		}

	end


	function MainMenu:update(dt) 

		self.sceneRoot:update(dt)
		self.cameraPos = self.cameraPos + self.cameraSpeed * dt
		if self.cameraPos > self.cameraRestartPos then
			self.cameraPos = 0
		end

	end


	function MainMenu:handleMessage(msg)

		self.sceneRoot:handleMessage(msg)

	end


	function MainMenu:draw() 

		love.graphics.push()
		love.graphics.translate(-self.cameraPos, 0)
		self.bg:draw()
		love.graphics.pop()

		self.heroSprite:draw()
		self.sceneRoot:draw()
		self.btn1Text:draw()
		self.btn2Text:draw()
		self.btn3Text:draw()
		self.titleText:draw()
		
	
	end


end