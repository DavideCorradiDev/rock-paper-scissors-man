-- Copyright (c) 2016 Davide Corradi - All rights reserved.

local class = require 'hzi.class'
local hmath = require 'hzi.math'
local msg = require 'hzi.message'
local errors = require 'hzi.errors'
local love = love
local table = table
local assert = assert
local ipairs = ipairs
local type = type

local filename = ...

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end



	Node = class.declare(filename, msg.MessageHandler, hmath.Transformable)



	function Node:new(arg)
		arg = arg or {}
		msg.MessageHandler.new(self)
		hmath.Transformable.new(self, arg)
		
		self._parent = nil
		self._children = {}
		self._childrenIndexes = {}
		if arg.updating == false then self._updating = false else self._updating = true end
		if arg.listening == false then self._listening = false else self._listening = true end
		if arg.visible == false then self._visible = false else self._visible = true end
		self._deleted = false
	end



	function Node:attachChild(child)
		assert(class.typeOf(child, Node:type()), errors.badPolymorphicType(2, 'attachChild', Node:type()))
		assert(child._parent == nil, '\'attachChild\': child already has a parent.')
		assert(child ~= self, '\'attachChild\': cannot attach the node as a child of itself.')
		child._parent = self
		table.insert(self._children, child)
		self._childrenIndexes[child] = table.getn(self._children)
	end



	function Node:detachChild(child)
		assert(self._childrenIndexes[child], '\'detachChild\': child not found.')
		child._parent = nil
		table.remove(self._children, self._childrenIndexes[child])
		self._childrenIndexes[child] = nil
	end



	function Node:update(dt)

		if self:isUpdating() then
			self:_onUpdate(dt)
			self:_updateChildren(dt)
		end

	end



	function Node:_updateChildren(dt)

		for i, child in ipairs(self._children) do
			child:update(dt)
		end

	end



	function Node:_onUpdate(dt)
		-- Do nothing as basic behaviour.
	end



	function Node:draw()

		if self:isVisible() then
			love.graphics.pushTransform(self._transform)
			self:_onDraw()
			self:_drawChildren()
			love.graphics.pop()
		end

	end



	function Node:_drawChildren()

		for i, child in ipairs(self._children) do
			child:draw(dt)
		end

	end



	function Node:_onDraw()
		-- Do nothing as basic behaviour.
	end



	function Node:removeDeletedChildren()

		for i = table.getn(self._children), 1, -1 do
			local child = self._children[i]
			if child:isDeleted() then 
				child._parent = nil
				table.remove(self._children, i)
				self._childrenIndexes[child] = nil
			else
				child:removeDeletedChildren()
			end
		end

	end



	function Node:delete()

		self._deleted = true

	end



	function Node:undelete()
		self._deleted = false
	end



	function Node:isDeleted()

		return self._deleted or self:_isDeletable()

	end



	function Node:_isDeletable()

		return false

	end



	function Node:handleMessage(message)

		if self:isListening() then
			if self:_sendMessageToChildren(message) then return true end
			return msg.MessageHandler.handleMessage(self, message)
		end
		return false

	end



	function Node:_sendMessageToChildren(message)

		for i = table.getn(self._children), 1, -1 do
			if self._children[i]:handleMessage(message) then return true end
		end
		return false

	end



	function Node:isUpdating()

		if not self._parent then
			return self._updating
		else
			return self._updating and self._parent:isUpdating()
		end

	end



	function Node:setUpdating(value)

		self._updating = value

	end



	function Node:isListening()

		if not self._parent then
			return self._listening
		else
			return self._listening and self._parent:isListening()
		end

	end



	function Node:setListening(value)

		self._listening = value

	end



	function Node:isVisible()

		if not self._parent then
			return self._visible
		else
			return self._visible and self._parent:isVisible()
		end

	end



	function Node:setVisible(value)

		self._visible = value

	end



	function Node:getGlobalPosition()

		if self._parent then
			return self._parent:getGlobalTransformMatrix() * self._transform:getPosition()
		else
			return self._transform:getPosition()
		end

	end



	function Node:getGlobalRotation()

		if self._parent then
			return self._parent:getGlobalRotation() + self._transform:getRotation()
		else
			return self._transform:getRotation()
		end

	end



	function Node:getGlobalTransformMatrix()

		if self._parent then
			return self._parent:getGlobalTransformMatrix() * self._transform:getTransformMatrix()
		else
			return self._transform:getTransformMatrix()
		end

	end

	

	function Node:getGlobalInverseTransformMatrix()

		if self._parent then
			return self._transform:getInverseTransformMatrix() * self._parent:getGlobalInverseTransformMatrix()
		else
			return self._transform:getInverseTransformMatrix()
		end

	end


end