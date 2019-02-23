-- Copyright (c) 2016 Davide Corradi - All rights reserved.

local class = require 'hzi.class'
local errors = require 'hzi.errors'
local type = type
local assert = assert

local filename = ...

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end

	MessageHandler = class.declare(filename)



	function MessageHandler:new()
		self._callbacks = {}
	end



	function MessageHandler:addCallback(messageTag, callback)
		self._callbacks[messageTag] = callback
	end



	function MessageHandler:removeCallback(messageTag)
		self._callbacks[messageTag] = nil
	end



	function MessageHandler:handleMessage(message)
		assert(type(message) == 'table', errors.badType(2, 'handleMessage', 'table', type(message)))
		if self._callbacks[message.tag] then
			return self._callbacks[message.tag](self, message)
		else
			return false
		end
	end

end