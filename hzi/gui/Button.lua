-- Copyright (c) 2016 Davide Corradi - All rights reserved.

local class = require 'hzi.class'
local hmath = require 'hzi.math'
local res = require 'hzi.resources'
local love = love

local print = print

local filename = ...

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end

	Button = class.declare(filename, Component)



	function Button:new(arg)
		arg = arg or {}
		Component.new(self, arg)
		self.visual = arg.visual or Button.Rectangle()
		self.callback = arg.callback or function() end
	end



	function Button:_containsMouse(x, y)

		local mousePos = hmath.Vector2(x, y)
		local localmousePos = self:getGlobalInverseTransformMatrix() * mousePos
		return self.visual:containsMouse(localmousePos, self:getStatus())
		
	end



	function Button:_onMouseMoved(msg)

		if self:_containsMouse(msg.x, msg.y) then
			self:select()
			return true
		else
			self:deselect()
			return false
		end

	end



	function Button:_onMousePressed(msg)

		if self:isSelected() then
			self:gainFocus()
			return true
		end
		return false

	end



	function Button:_onMouseReleased(msg)

		if self:isFocused() then
			self:loseFocus()
			if self:_containsMouse(msg.x, msg.y) then
				self.callback()
				return true
			end
		end 
		return false

	end



	function Button:_onKeyPressed(msg)

		if msg.key == 'return' then
			return self:_onActivationKey()
		end
		return false

	end



	function Button:_onGamepadPressed(msg)
		if msg.button == 'a' then
			return self:_onActivationKey()
		end
		return false
	end



	function Button:_onActivationKey()

		if self:isSelected() then 
			self.callback()
			return true
		end
		return false

	end



	function Button:_onDraw()
		self.visual:draw(self:getStatus())
	end



	Button.Rectangle = class.declare(filename .. '.Rectangle')



	function Button.Rectangle:new(arg)
		arg = arg or {}
		self.width = arg.width or 40
		self.height = arg.height or 20
		self.fillNormal = arg.fillNormal or res.Color(200, 200, 200)
		self.fillSelected = arg.fillSelected or res.Color(255, 255, 255)
		self.fillFocused = arg.fillFocused or res.Color(255, 200, 200)
		self.lineNormal = arg.lineNormal or res.Color(0, 0, 0)
		self.lineSelected = arg.lineSelected or res.Color(0, 0, 0)
		self.lineFocused = arg.lineFocused or res.Color(0, 0, 0)
	end



	function Button.Rectangle:draw(status)
		if status == 'selected' then
			love.graphics.setColorObject(self.fillSelected)
		elseif status == 'focused' then
			love.graphics.setColorObject(self.fillFocused)
		else
			love.graphics.setColorObject(self.fillNormal)
		end
		love.graphics.rectangle('fill', 0, 0, self.width, self.height)

		if status == 'selected' then
			love.graphics.setColorObject(self.lineSelected)
		elseif status == 'focused' then
			love.graphics.setColorObject(self.lineFocused)
		else
			love.graphics.setColorObject(self.lineNormal)
		end
		love.graphics.rectangle('line', 0, 0, self.width, self.height)
	end



	function Button.Rectangle:containsMouse(localmousePos, status)
		if localmousePos.x < 0
			or localmousePos.y < 0
			or localmousePos.x >= self.width
			or localmousePos.y >= self.height then
			return false
		else
			return true
		end
	end

end