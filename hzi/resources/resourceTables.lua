-- Copyright (c) 2016 Davide Corradi - All Rights Reserved

local setmetatable = setmetatable
local rawset = rawset
local error = error
local love = love

local filename = ...

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end

	-- Creates a new resource table.
	local function createResourceTable(f)
		T = setmetatable({},
			{
				-- When a non-existent resource is asked for, load the new resource.
				__index = function(self, k)
					-- Load the resource
					local v = f(k)
					-- Set the key value pair in the table.
					rawset(self, k, v)
					-- Return a reference to the resource so that it can be used immediately.
					return v
				end,
			})

		-- Clear the table.
		function T:clear()
			for k, v in pairs(self) do
				rawset(self, k, nil)
			end
		end

		return T
	end



	--- contains the images.
	--- @field image
	image = createResourceTable(function(k) return love.graphics.newImage('data/image/' .. k .. '.png') end)

	--- contains short sound effects. Sound effects are fully loaded in memory.
	--- @field sound
	sound = createResourceTable(function(k) return love.sound.newSoundData('data/sound/' .. k .. '.wav') end)

	--- contains music tracks. Music tracks are buffered from the disk.
	--- @field music
	music = createResourceTable(function(k) return love.audio.newSource('data/music/' .. k .. '.mp3') end)

end