-- Copyright (c) 2016 Davide Corradi - All Rights Reserved

local class = require 'hzi.class'

local filename = ...

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end



	State = class.declare(filename)



	function State:new() end
	function State:update(dt) end
	function State:handleMessage(msg) end
	function State:draw() end


end