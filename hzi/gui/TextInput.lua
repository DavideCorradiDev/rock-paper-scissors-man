-- Copyright (c) 2016 Davide Corradi - All rights reserved.

local class = require 'hzi.class'
local hmath = require 'hzi.math'
local res = require 'hzi.resources'
local math = math
local string = string
local love = love

local print = print

local filename = ...



return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end

	TextInput = class.declare(filename, Component)



	function TextInput:new(arg)
		arg = arg or {}
		Component.new(self, arg)
		self.visual = arg.visual or TextInput.Rectangle()
		self._cursorPosition = 0
		self:setText(arg.text)
	end



	function TextInput:getText()
		return self._text
	end



	function TextInput:setText(text)
		self._text = text or ''
		self._textDrawStart = 1
		self._textDrawEnd = string.len(self._text)
		self:_updateVisibleText()
	end



	function TextInput:_updateVisibleText()

		local text = string.sub(self._text, self._textDrawStart, self._textDrawEnd)
		if not self.visual:textFits(text) then
			text = string.sub(self._text, self._textDrawStart, self._cursorPosition)
			if self.visual:textFits(text) then
				self._textDrawStart = self._cursorPosition + 1
				for i = string.len(self._text), self._textDrawStart + 1, -1 do
					text = string.sub(self._text, self._textDrawStart, i)
					if self.visual:textFits(text) then
						self._textDrawEnd = i
						break
					end
				end
			else
				self._textDrawEnd = self._cursorPosition
				for i = 1, self._cursorPosition do
					text = string.sub(self._text, i, self._cursorPosition)
					if self.visual:textFits(text) then
						self._textDrawStart = i
						break
					end
				end
			end
		elseif self._cursorPosition + 1 < self._textDrawStart then
			self._textDrawStart = self._cursorPosition + 1
			for i = string.len(self._text), self._textDrawStart + 1, -1 do
				text = string.sub(self._text, self._textDrawStart, i)
				if self.visual:textFits(text) then
					self._textDrawEnd = i
					break
				end
			end
		elseif self._cursorPosition > self._textDrawEnd then
			self._textDrawEnd = self._cursorPosition
			for i = 1, self._cursorPosition do
				text = string.sub(self._text, i, self._cursorPosition)
				if self.visual:textFits(text) then
					self._textDrawStart = i
					break
				end
			end
		end

	end



	function TextInput:_containsMouse(x, y)

		local mousePos = hmath.Vector2(x, y)
		local localmousePos = self:getGlobalInverseTransformMatrix() * mousePos
		return self.visual:containsMouse(localmousePos, self:getStatus())
		
	end



	function TextInput:_onMouseMoved(msg)

		if self:_containsMouse(msg.x, msg.y) then
			self:select()
			return true
		else
			self:deselect()
			return false
		end

	end



	function TextInput:_onMousePressed(msg) 

		if msg.button == 1 then
			if self:_containsMouse(msg.x, msg.y) then
				if self:isFocused() then 
					local mx = msg.x - self:getGlobalPosition().x
					for i = 1, string.len(self._text) do
						local s = string.sub(self._text, 1, i)
						if self.visual.font:getWidth(s) >= mx then
							self._cursorPosition = i - 1
							break
						end
					end
				else
					self:gainFocus()
					self:_moveCursorToEnd()
				end
				return true
			else
				self:loseFocus()
				return false
			end
		elseif msg.button == 2 then
			self:loseFocus()
			return false
		end
		return false

	end



	function TextInput:_onTextInput(msg)

		if self:isFocused() then 
			local before = string.sub(self._text, 1, self._cursorPosition)
			local after = string.sub(self._text, self._cursorPosition + 1)
			self._text = before .. msg.text .. after
			self._cursorPosition = self._cursorPosition + string.len(msg.text)
			self:_updateVisibleText()
		end

	end



	function TextInput:_onKeyPressed(msg)

		if self:isFocused() then
			if msg.key == 'return' then
				self:loseFocus()
			elseif msg.key == 'escape' then
				self:loseFocus()
			elseif msg.key == 'left' then
				self:_moveCursorLeft()
			elseif msg.key == 'right' then
				self:_moveCursorRight()
			elseif msg.key == 'home' then
				self:_moveCursorToStart()
			elseif msg.key == 'end' then
				self:_moveCursorToEnd()
			elseif msg.key == 'backspace' then
				self:_deletePreviousCharacter()
			elseif msg.key == 'delete' then
				self:_deleteNextCharacter()
			end
			return true

		elseif self:isSelected() then
			if msg.key == 'return' then
				self:gainFocus()
				self._cursorPosition = 0
				return true 
			end
		end

		return false
	end



	function TextInput:_moveCursorLeft() 

		self._cursorPosition = math.max(0, self._cursorPosition - 1)
		self:_updateVisibleText()

	end



	function TextInput:_moveCursorRight() 

		self._cursorPosition = math.min(string.len(self._text), self._cursorPosition + 1)
		self:_updateVisibleText()

	end



	function TextInput:_moveCursorToStart()

		self._cursorPosition = 0
		self:_updateVisibleText()

	end



	function TextInput:_moveCursorToEnd()

		self._cursorPosition = string.len(self._text)
		self:_updateVisibleText()

	end



	function TextInput:_deletePreviousCharacter()

		if self._cursorPosition > 0 then 
			local before = string.sub(self._text, 1, self._cursorPosition - 1)
			local after = string.sub(self._text, self._cursorPosition + 1)
			self._text = before .. after
			self:_moveCursorLeft()
		end

	end



	function TextInput:_deleteNextCharacter()

		local before = string.sub(self._text, 1, self._cursorPosition)
		local after = string.sub(self._text, self._cursorPosition + 2)
		self._text = before .. after

	end



	function TextInput:_onDraw()


		self.visual:draw(self:getStatus(), 
			string.sub(self._text, self._textDrawStart, self._textDrawEnd), 
			self._cursorPosition - self._textDrawStart + 1)

	end



	TextInput.Rectangle = class.declare(filename .. '.Rectangle')



	function TextInput.Rectangle:new(arg)
		arg = arg or {}
		self.width = arg.width or 80
		self.height = arg.height or 20
		self.fillNormal = arg.fillNormal or res.Color(25, 25, 25)
		self.fillSelected = arg.fillSelected or res.Color(50, 50, 50)
		self.fillFocused = arg.fillFocused or res.Color(50, 50, 50)
		self.lineNormal = arg.lineNormal or res.Color(0, 0, 0)
		self.lineSelected = arg.lineSelected or res.Color(0, 0, 0)
		self.lineFocused = arg.lineFocused or res.Color(0, 0, 0)
		self.font = arg.font or love.graphics.getFont()
		self.textColor = arg.textColor or res.Color(255, 255, 255)
		self.hmargin = arg.hmargin or 4
	end



	function TextInput.Rectangle:draw(status, text, cursorPosition)
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

		local vmargin = 0.5 * self.height - 0.5 * self.font:getHeight()

		love.graphics.setColor(self.textColor.r, self.textColor.g, self.textColor.b, self.textColor.a) 
		love.graphics.setFont(self.font)
		love.graphics.print(text, self.hmargin, vmargin)

		if status == 'focused' then
			local subText = string.sub(text, 1, cursorPosition)
			local pos = self.font:getWidth(subText) - self:_computeCursorOffset()
			love.graphics.print('|', pos + self.hmargin, vmargin)
		end

	end



	function TextInput.Rectangle:textFits(text)
		local maxw = (self.width - 2 * self.hmargin)
		return self.font:getWidth(text) <= maxw 
	end



	function TextInput.Rectangle:containsMouse(localmousePos, status)
		if localmousePos.x < 0
			or localmousePos.y < 0
			or localmousePos.x >= self.width
			or localmousePos.y >= self.height then
			return false
		else
			return true
		end
	end



	function TextInput.Rectangle:_computeCursorOffset()

		return self.font:getWidth('|') * 0.5

	end

end