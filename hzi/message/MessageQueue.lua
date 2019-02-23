-- Copyright (c) 2016 Davide Corradi - All rights reserved.

local class = require 'hzi.class'
local errors = require 'hzi.errors'
local table = table
local assert = assert
local type = type

local filename = ...

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end



	MessageQueue = class.declare(filename)



	function MessageQueue:new()
		self._messages = {}
	end



	function MessageQueue:pushMessage(message)
		assert(type(message) == 'table', errors.badType(2, 'pushMessage', 'table', type(message)))
		table.insert(self._messages, message)
	end



	function MessageQueue:popMessage()
		return table.remove(self._messages, 1)
	end



	function MessageQueue:isEmpty()
		return table.getn(self._messages) == 0
	end

end