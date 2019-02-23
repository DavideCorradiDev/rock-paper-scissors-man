-- Copyright (c) 2016 Davide Corradi - All rights reserved.

local class = require 'hzi.class'
local hmath = require 'hzi.math'
local scene = require 'hzi.scene'
local love = love
local assert = assert

local print = print

local filename = ...

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end



	Component = class.declare(filename, scene.Node)



	local selected = nil
	local focused = nil



	function Component:new(arg)
		arg = arg or {}
		scene.Node.new(self, arg)

		self:addCallback('mousemoved', self._onMouseMoved)
		self:addCallback('mousepressed', self._onMousePressed)
		self:addCallback('mousereleased', self._onMouseReleased)
		self:addCallback('keypressed', self._onKeyPressed)
		self:addCallback('keyreleased', self._onKeyReleased)
		self:addCallback('textinput', self._onTextInput)
		self:addCallback('gamepadaxis', self._onGamepadAxis)
		self:addCallback('gamepadpressed', self._onGamepadPressed)
		self:addCallback('gamepadreleased', self._onGamepadReleased)
	end



	function Component:isSelected()
		return selected == self
	end



	function Component:select()
		selected = self
	end



	function Component:deselect()
		if selected == self then selected = nil end
	end



	function Component.isSomethingSelected()
		return selected ~= nil
	end



	function Component:isFocused()
		return focused == self
	end



	function Component:gainFocus()
		focused = self
	end



	function Component:loseFocus()
		if focused == self then focused = nil end
	end



	function Component.isSomethingFocused()
		return focused ~= nil
	end



	function Component:getStatus()
		if self:isFocused() then
			return 'focused'
		elseif self:isSelected() then
			return 'selected'
		else
			return 'normal'
		end

	end



	function Component:_onKeyPressed(msg) return false end
	function Component:_onKeyReleased(msg) return false end
	function Component:_onMouseMoved(msg) return false end
	function Component:_onMousePressed(msg) return false end
	function Component:_onMouseReleased(msg) return false end
	function Component:_onTextInput(msg) return false end
	function Component:_onGamepadAxis(msg) return false end
	function Component:_onGamepadPressed(msg) return false end
	function Component:_onGamepadReleased(msg) return false end


	function Component:_onDraw()
		-- Intentionally blank.
	end

end
