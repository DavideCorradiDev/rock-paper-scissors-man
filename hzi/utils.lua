-- Copyright (c) 2016 Davide Corradi - All Rights Reserved

local getmetatable = getmetatable
local setmetatable = setmetatable
local pairs = pairs
local type = type
local assert = assert

local P = {}
if setfenv then setfenv(1, P) else _ENV = P end



function equals(a, b)

	if type(a) ~= type(b) then
		return false
	elseif type(b) == 'table' then
		-- Compare the metatable.
		if  getmetatable(a) ~= getmetatable(b) then
			return false
		end
		-- Need to do two loops, one per table, otherwise would return true if b is a subset of a.
		for k, v in pairs(b) do
			-- Make this chek to avoid infinite recursion when a table contains a reference to itself.
			if b ~= v then
				if not equals(a[k], b[k]) then
					return false
				end
			end
		end
		for k, v in pairs(a) do
			-- Make this chek to avoid infinite recursion when a table contains a reference to itself.
			if a ~= v then
				if not equals(a[k], b[k]) then
					return false
				end
			end
		end
		return true
	else
		return a == b
	end

end



function clone(a)

	if type(a) == 'table' then
		local new = {}
		setmetatable(new, getmetatable(a))
		for k, v in pairs(a) do
			new[k] = clone(v)
		end
		return new
	else
		return a
	end

end



function copy(a, b)

	assert(type(a) == 'table' and type(b) == 'table', 'Arguments must be of type \'table\'.')
	setmetatable(a, getmetatable(b))
	for k, v in pairs(b) do
		if type(v) == 'table' then
			copy(a[k], v)
		else
			a[k] = v
		end
	end

end


return P