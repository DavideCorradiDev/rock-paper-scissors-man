--- main module.
--- @module main


function love.run()
 
	if love.math then
		love.math.setRandomSeed(os.time())
	end
 
	if love.load then love.load(arg) end
 
	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end
 
	local dt = 0
	local updatedt = 1 / 60
	local updateTime = 0
 
	-- Main loop time.
	while true do
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end
 
		-- Update dt, as we'll be passing it to update
		if love.timer then
			love.timer.step()
			dt = love.timer.getDelta()
			updateTime = updateTime + dt
		end
 
		-- Call update and draw
		if love.update then 
			while updateTime > updatedt do
				love.update(updatedt) 
				updateTime = updateTime - updatedt
			end
		end -- will pass 0 if love.timer is disabled
 
		if love.graphics and love.graphics.isActive() then
			love.graphics.clear(love.graphics.getBackgroundColor())
			love.graphics.origin()
			if love.draw then love.draw() end
			love.graphics.present()
		end
 
		if love.timer then love.timer.sleep(0.001) end
	end
 
end


local hzi = {}
local game = {}

local WIDTH = 288
local HEIGHT = 216
local pixelScale = 3
local msgQueue
local canvas
local bevelTexture3
local bevelBG
local settings = {}
playerJoystick = {}

function love.load()
	
	love.graphics.setDefaultFilter('nearest', 'nearest', 0)

	local joysticks = love.joystick.getJoysticks()
	if table.getn(joysticks) >= 1 and joysticks[1]:isGamepad() then
		playerJoystick[1] = joysticks[1]
		print(playerJoystick)
	end

	require 'hzi.lovext'
	hzi.app = require 'hzi.app'
	hzi.message = require 'hzi.message'
	hzi.math = require 'hzi.math'
	hzi.resources = require 'hzi.resources'
	game.app = require 'game.app'

	settings.applyBevel = true

	bevelTexture3 = hzi.resources.image.bevel3
	bevelTexture3:setWrap('repeat', 'repeat')
	bevelBG = hzi.resources.Sprite{
		image = bevelTexture3,
		rect = hzi.math.Rect(0, 0, WIDTH * pixelScale, HEIGHT * pixelScale)
	}



	

	msgQueue = hzi.message.MessageQueue()
	canvas = love.graphics.newCanvas(WIDTH, HEIGHT)
	love.graphics.setBackgroundColor(0, 0, 0)
	hzi.app.push(game.app.MainMenu())

	

end



function love.update(dt)
	hzi.app.update(dt)
	while not msgQueue:isEmpty() do
		msg = msgQueue:popMessage()
		hzi.app.handleMessage(msg)
	end
	if hzi.app.emptyStack() then
		love.event.quit()
	end
end



function love.draw()

	love.graphics.setCanvas(canvas)
	love.graphics.clear()
	love.graphics.setBlendMode('alpha')

	hzi.app.draw()

	love.graphics.setCanvas()
	love.graphics.setBlendMode('alpha', 'premultiplied')

	love.graphics.push()
		love.graphics.scale(pixelScale, pixelScale)
		love.graphics.setColor(1 ,1 ,1 ,1 )
		love.graphics.draw(canvas)
	love.graphics.pop()

	if settings.applyBevel then
		love.graphics.setBlendMode('alpha')
		bevelBG:draw()
	end
end



-- function love.mousemoved(x, y, dx, dy)
-- 	msgQueue:pushMessage(hzi.message.createMouseMovedMessage(x, y, dx, dy))
-- end

-- function love.mousepressed(x, y, button, istouch)
-- 	msgQueue:pushMessage(hzi.message.createMousePressedMessage(x, y, button, istouch))
-- end 

-- function love.mousereleased(x, y, button, istouch)
-- 	msgQueue:pushMessage(hzi.message.createMouseReleasedMessage(x, y, button, istouch))
-- end

function love.keypressed(key, scancode, isrepeat)
	msgQueue:pushMessage(hzi.message.createKeyPressedMessage(key, scancode, isrepeat))

end

function love.keyreleased(key, scancode)
	msgQueue:pushMessage(hzi.message.createKeyReleasedMessage(key, scancode))
end

function love.textinput(text)
	msgQueue:pushMessage(hzi.message.createTextInputMessage(text))
end

-- function love.joystickpressed(joystick, button)
-- 	msgQueue:pushMessage(hzi.message.createJoystickPressedMessage(joystick, button))
-- end

-- function love.joystickreleased(joystick, button)
-- 	msgQueue:pushMessage(hzi.message.createJoystickReleasedMessage(joystick, button))
-- end

-- function love.joystickaxis(joystick, axis, value)

-- 	msgQueue:pushMessage(hzi.message.createJoystickAxisMessage(joystick, axis, value))
-- end

function love.joystickadded(joystick)
	local joysticks = love.joystick.getJoysticks()
	if table.getn(joysticks) >= 1 and joysticks[1]:isGamepad() then
		playerJoystick[1] = joysticks[1]
	end
	msgQueue:pushMessage(hzi.message.createJoystickAddedMessage(joystick))
end

function love.gamepadpressed(joystick, button)
	msgQueue:pushMessage(hzi.message.createGamepadPressedMessage(joystick, button))
end

function love.gamepadreleased(joystick, button)
	msgQueue:pushMessage(hzi.message.createGamepadReleasedMessage(joystick, button))
end

function love.gamepadaxis(joystick, axis, value)

	msgQueue:pushMessage(hzi.message.createGamepadAxisMessage(joystick, axis, value))
end
