-- Copyright (c) 2016 Davide Corradi - All rights reserved.

assert(love, 'Love libraries not loaded.')

local hmath = require 'hzi.math'
local class = require 'hzi.class'



function love.graphics.pushTransform(transform)

	assert(class.type(transform) == hmath.Transform:type(), 
		'Argument 1 must be of type \'' .. hmath.Transform:type() .. '\'.')

	love.graphics.push()
	love.graphics.translate(transform._position.x, transform._position.y)
	love.graphics.rotate(math.rad(transform._rotation))
	love.graphics.scale(transform._scale.x, transform._scale.y)
	love.graphics.translate(-transform._origin.x, -transform._origin.y)

end



function love.graphics.setColorObject(color)
	love.graphics.setColor(color.r, color.g, color.b, color.a)
end