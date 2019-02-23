-- Copyright (c) 2016 Davide Corradi - All Rights Reserved
-- This module is an extension of luaunit (see 'luaunit.lua' for copyright details.)


local class = require 'hzi.class'
local string = string
local tostring = tostring
local type = type

-- Package instantiation.
local P = require 'hzi.unittest.luaunit'
if setfenv then setfenv(1, P) else _ENV = P end



local function errorMsgObjectEquality(actual, expected)
	if not P.ORDER_ACTUAL_EXPECTED then
		expected, actual = actual, expected
	end
	if type(expected) == 'string'  then
		expected, actual = private.prettystrPadded(expected, actual)
		return string.format("expected: %s\nactual: %s", expected, actual)
	elseif type(expected) == 'table' then
		if expected.__tostring ~= nil then
			expected = tostring(expected)
		else
			expected = private.prettystrPadded(expected)
		end
		if actual.__tostring ~= nil then
			actual = tostring(actual)
		else
			actual = private.prettystrPadded(actual)
		end
		return string.format("expected: %s\nactual: %s", expected, actual)
	end
	return string.format("expected: %s, actual: %s", private.prettystr(expected), private.prettystr(actual))
end



function assertObjectEquals(actual, expected)
	if not class.equals(actual, expected) then
		private.failure(errorMsgObjectEquality(actual, expected), 2)
	end
end



function assertObjectNotEquals(actual, expected)
	if class.equals(actual, expected) then
		if type(actual) == 'table' and actual.__tostring ~= nil then
			actual = tostring(actual)
		else
			actual = private.prettystr(actual)
		end
		private.fail_fmt(2, 'Received the not expected value: %s', actual)
	end
end



return P