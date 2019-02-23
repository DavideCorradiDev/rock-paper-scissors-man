local class = require 'hzi.class'
local app = require 'hzi.app'
local gui = require 'hzi.gui'
local hmt = require 'hzi.math'
local scene = require 'hzi.scene'
local res = require 'hzi.resources'
local love = love
local table = table

local ipairs = ipairs
local print = print

local filename = ...

local SCREENW = 16 * 18
local SCREENH = 16 * 13.5

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end

	HelpScreen = class.declare(filename, app.State)

	local pages = {
		res.Sprite{ image = res.image.help1 },
		res.Sprite{ image = res.image.help2 },
		res.Sprite{ image = res.image.help3 },
		res.Sprite{ image = res.image.help4 },
	}

	function HelpScreen:new() 

		self._currentPage = 1

	end


	function HelpScreen:update(dt) end


	function HelpScreen:handleMessage(msg) 

		if msg.tag == 'keypressed' or msg.tag == 'gamepadpressed' then
			self._currentPage = self._currentPage + 1
			if self._currentPage > table.getn(pages) then
				app.pop()
			end
		end

	end


	function HelpScreen:draw() 
		if self._currentPage <= table.getn(pages) then
			pages[self._currentPage]:draw()
		end

	end

end