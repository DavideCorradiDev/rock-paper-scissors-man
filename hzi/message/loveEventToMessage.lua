-- Copyright (c) 2016 Davide Corradi - All rights reserved.

local filename = ...

return function(P)

	if setfenv then setfenv(1, P) else _ENV = P end

	function createMouseMovedMessage(x, y, dx, dy)
		return {
			tag = 'mousemoved',
			x = x,
			y = y,
			dx = dx,
			dy = dy,
		}
	end

	function createMousePressedMessage(x, y, button, istouch)
		return {
			tag = 'mousepressed',
			x = x,
			y = y,
			button = button,
			istouch = istouch,
		}
	end

	function createMouseReleasedMessage(x, y, button, istouch)
		return {
			tag = 'mousereleased',
			x = x,
			y = y,
			button = button,
			istouch = istouch,
		}
	end

	function createKeyPressedMessage(key, scancode, isrepeat)
		return {
			tag = 'keypressed',
			key = key,
			scancode = scancode,
			isrepeat = isrepeat,
		}
	end

	function createKeyReleasedMessage(key, scancode)
		return {
			tag = 'keyreleased',
			key = key,
			scancode = scancode,
		}
	end

	function createTextInputMessage(text)
		return {
			tag = 'textinput',
			text = text,
		}
	end

	function createJoystickPressedMessage(joystick, button)
		return {
			tag = 'joystickpressed',
			joystick = joystick,
			button = button,
		}
	end

	function createJoystickReleasedMessage(joystick, button)
		return {
			tag = 'joystickreleased',
			joystick = joystick,
			button = button,
		}
	end

	function createJoystickAxisMessage(joystick, axis, value)
		return {
			tag = 'joystickaxis',
			joystick = joystick,
			axis = axis,
			value = value,
		}
	end

	function createJoystickAddedMessage(joystick)
		return {
			tag = 'joystickadded',
			joystick = joystick,
		}
	end

	function createGamepadPressedMessage(joystick, button)
		return {
			tag = 'gamepadpressed',
			joystick = joystick,
			button = button,
		}
	end

	function createGamepadReleasedMessage(joystick, button)
		return {
			tag = 'gamepadreleased',
			joystick = joystick,
			button = button,
		}
	end

	function createGamepadAxisMessage(joystick, axis, value)
		return {
			tag = 'gamepadaxis',
			joystick = joystick,
			axis = axis,
			value = value,
		}
	end

end