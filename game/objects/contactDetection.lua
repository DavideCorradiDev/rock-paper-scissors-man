-- Copyright (c) 2016 Davide Corradi - All Rights Reserved

local class = require 'hzi.class'
local res = require 'hzi.resources'
local hmt = require 'hzi.math'
local love = love

local print = print

local filename = ...

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end

	local function checkCircleCircle(cs1, cs2)
		local distance = cs1:getPosition() - cs2:getPosition()
		local minDistance = cs1:getRadius() + cs2:getRadius()
		if distance:squareNorm() < minDistance * minDistance then
			return true
		else
			return false
		end
	end

	local checkFunctions = {}
	checkFunctions[CircleContact:type()] = {}
	checkFunctions[CircleContact:type()][CircleContact:type()] = checkCircleCircle

	function checkContact(cs1, cs2)

		return checkFunctions[cs1:type()][cs2:type()](cs1, cs2)

	end

end