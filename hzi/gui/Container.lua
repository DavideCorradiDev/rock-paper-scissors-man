-- Copyright (c) 2016 Davide Corradi - All rights reserved.

local class = require 'hzi.class'
local scene = require 'hzi.scene'
local res = require 'hzi.resources'
local errors = require 'hzi.errors'
local love = love
local math = math
local table = table
local ipairs = ipairs
local pairs = pairs
local assert = assert

local print = print

local filename = ...

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end

	Container = class.declare(filename, Component)



	local root = nil
	local shiftPressed = false



	function Container:new(arg)
		arg = arg or {}
		Component.new(self, arg)
		self.visual = arg.visual or Container.Rectangle()
		self.cols = arg.cols or 1 
		assert(self.cols >= 1, '\'new\': number of columns must be >= 1')
		if arg.selectable ~= nil then self.selectable = arg.selectable else self.selectable = true end
	end



	function Container:attachChild(child)
		assert(class.typeOf(child, Component.type()), errors.badPolymorphicType(2, 'attachChild', Component.type()))
		scene.Node.attachChild(self, child)
	end



	function Container:select()
		if self.selectable then
			Component.select(self)
		elseif self._children[1] then
			self._children[1]:select()
		end
	end



	function Container:getSelectedChild()

		for i, child in ipairs(self._children) do
			if child:isSelected() then return i end
		end
		return nil

	end



	function Container:isRoot()
		return root == self
	end



	function Container:setAsRoot()
		root = self
	end



	function Container:removeAsRoot()
		if root == self then root = nil end
	end



	function Container:_selectIfRoot()
		if not Component.isSomethingSelected() and self:isRoot() then
			self:select()
			return true
		end
	end


	function Container:_onDraw()
		self.visual:draw(self:getStatus())
	end



	function Container:_onKeyPressed(msg)

		if Component.isSomethingFocused() then
			return false
		end

		if msg.key == 'return' then
			return self:_onActivationKey()
		elseif msg.key == 'escape' then
			return self:_onDeactivationKey()
		elseif msg.key == 'lshift' then
			shiftPressed = true
			return true
		elseif msg.key == 'left' then
			if self:_selectIfRoot() then return true end
			return self:_onLeftKey()
		elseif msg.key == 'right' then
			if self:_selectIfRoot() then return true end
			return self:_onRightKey()
		elseif msg.key == 'up' then
			if self:_selectIfRoot() then return true end
			return self:_onUpKey()
		elseif msg.key == 'down' then
			if self:_selectIfRoot() then return true end
			return self:_onDownKey()
		elseif msg.key == 'tab' then
			if self:_selectIfRoot() then return true end
			if shiftPressed then
				return self:_onSelectPreviousKey()
			else
				return self:_onSelectNextKey()
			end
		end
		return false

	end



	function Container:_onKeyReleased(msg)

		if msg.key == 'lshift' then
			shiftPressed = false
		end
		return false
	end


	local axisXMoved = false
	local axisYMoved = false
	function Container:_onGamepadAxis(msg)

		local tol = 0.5
		if math.abs(msg.value) > tol then
			if msg.axis == 'leftx' then
				if not axisXMoved then
					axisXMoved = true
					if msg.value < 0 then
						if self:_selectIfRoot() then return true end
						self:_onLeftKey()
					elseif msg.value > 0 then
						if self:_selectIfRoot() then return true end
						self:_onRightKey()
					end
				end
			elseif msg.axis == 'lefty' then
				if not axisYMoved then
					axisYMoved = true
					if msg.value < 0 then
						if self:_selectIfRoot() then return true end
						self:_onUpKey()
					elseif msg.value > 0 then
						if self:_selectIfRoot() then return true end
						self:_onDownKey()
					end
				end
			end
		else
			if msg.axis == 'leftx' then
				axisXMoved = false
			elseif msg.axis == 'lefty' then
				axisYMoved = false
			end
		end
	end



	function Container:_onGamepadPressed(msg)
		if msg.button == 'a' then
			return self:_onActivationKey()
		elseif msg.button == 'b' then
			return self:_onDeactivationKey()
		end
		return false
	end


	function Container:_onActivationKey()

		if self:isSelected() and self._children[1] then
			self._children[1]:select()
			return true
		end

		return false

	end



	function Container:_onDeactivationKey()

		if self:getSelectedChild() then
			if self.selectable then
				self:select()
			end
			return true
		end

		return false

	end



	function Container:_onSelectNextKey()

		local i = self:getSelectedChild()
		if i then
			if i < table.getn(self._children) then
				self._children[i+1]:select()
			end
			return true
		end

		return false

	end



	function Container:_onSelectPreviousKey()

		local i = self:getSelectedChild()
		if i then
			if i > 1 then
				self._children[i-1]:select()
			end
			return true
		end

		return false

	end



	function Container:_computeRowColPosition(i)
		local i = i - 1
		local r = math.floor((i) / self.cols)
		local c = i % self.cols
		return r+1, c+1
	end



	function Container:_computeIdxPosition(r, c)
		return (r-1) * self.cols + c
	end



	function Container:_onLeftKey()

		local i = self:getSelectedChild()
		if i then
			local r, c = self:_computeRowColPosition(i)
			if c > 1 then
				local inext = self:_computeIdxPosition(r, c - 1)
				if inext >= 1 then
					self._children[inext]:select()
				end
			end
			return true
		end

		return false

	end



	function Container:_onRightKey()

		local i = self:getSelectedChild()
		if i then
			local r, c = self:_computeRowColPosition(i)
			if c < self.cols then
				local inext = self:_computeIdxPosition(r, c + 1)
				if inext <= table.getn(self._children) then
					self._children[inext]:select()
				end
			end
			return true
		end

		return false

	end



	function Container:_onUpKey()

		local i = self:getSelectedChild()
		if i then
			local r, c = self:_computeRowColPosition(i)
			local inext = self:_computeIdxPosition(r - 1, c)
			if inext >= 1 then
				self._children[inext]:select()
			end
			return true
		end

		return false

	end



	function Container:_onDownKey()

		local i = self:getSelectedChild()
		if i then
			local r, c = self:_computeRowColPosition(i)
			local inext = self:_computeIdxPosition(r + 1, c)
			if inext <= table.getn(self._children) then
				self._children[inext]:select()
			end
			return true
		end

		return false

	end



	Container.Rectangle = class.declare(filename .. '.Rectangle')



	function Container.Rectangle:new(arg)
		arg = arg or {}
		self.width = arg.width or 40
		self.height = arg.height or 20
		self.fillNormal = arg.fillNormal or res.Color(0.2, 0.2, 0.2)
		self.fillSelected = arg.fillSelected or res.Color(0.4, 0.4, 0.4)
		self.lineNormal = arg.lineNormal or res.Color(0, 0, 0)
		self.lineSelected = arg.lineSelected or res.Color(0, 0, 0)
	end



	function Container.Rectangle:draw(status)
		if status == 'selected' then
			love.graphics.setColorObject(self.fillSelected)
		else
			love.graphics.setColorObject(self.fillNormal)
		end
		love.graphics.rectangle('fill', 0, 0, self.width, self.height)

		if status == 'selected' then
			love.graphics.setColorObject(self.lineSelected)
		else
			love.graphics.setColorObject(self.lineNormal)
		end
		love.graphics.rectangle('line', 0, 0, self.width, self.height)
	end

end
