-- Copyright (c) 2016 Davide Corradi - All Rights Reserved

local table = table
local ipairs = ipairs

local filename = ...

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end

	local stateStack = {}
	local pendingChanges = {}

	function push(state)
		table.insert(pendingChanges, {
			tag = 'push',
			state = state,
		})
	end

	function pop()
		table.insert(pendingChanges, {
			tag = 'pop',
		})
	end

	function clear()
		table.insert(pendingChanges, {
			tag = 'clear',
		})
	end

	function update(dt)

		for i, change in ipairs(pendingChanges) do
			if change.tag == 'push' then
				table.insert(stateStack, change.state)
			elseif change.tag == 'pop' then
				table.remove(stateStack)
			elseif change.tag == 'clear' then
				stateStack = {}
			end
		end
		pendingChanges = {}

		local stateNum = table.getn(stateStack)
		if stateNum > 0 then
			stateStack[stateNum]:update(dt)
		end

	end

	function emptyStack()
		return table.getn(stateStack) == 0
	end

	function handleMessage(msg) 

		local stateNum = table.getn(stateStack)
		if stateNum > 0 then
			stateStack[stateNum]:handleMessage(msg)
		end

	end

	function draw()

		local stateNum = table.getn(stateStack)
		if stateNum > 0 then
			stateStack[stateNum]:draw()
		end

	end

end