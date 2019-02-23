local unittest = require 'hzi.unittest'
local utils = require 'hzi.utils'



TestUtils = {}



function TestUtils:testEquals()

	local num1 = 0
	local num2 = 0
	local num3 = 1

	unittest.assertTrue(utils.equals(num1, num2))
	unittest.assertFalse(utils.equals(num1, num3))

	local bool1 = false
	local bool2 = false
	local bool3 = true

	unittest.assertTrue(utils.equals(bool1, bool2))
	unittest.assertFalse(utils.equals(bool1, bool3))

	local string1 = 'hello'
	local string2 = 'hello'
	local string3 = 'world'

	unittest.assertTrue(utils.equals(string1, string2))
	unittest.assertFalse(utils.equals(string1, string3))

	local fun1 = function() print('pippo') end
	local fun2 = fun1
	local fun3 = function() print('pippo') end

	unittest.assertTrue(utils.equals(fun1, fun2))
	unittest.assertFalse(utils.equals(fun1, fun3))

	local tab1 = {x = 0, y = 1, t = {a = 3, b = 4}}
	local tab2 = {x = 0, y = 1, t = {a = 3, b = 4}}
	local tab3 = {x = 0, y = 1, t = {a = 3}}
	local tab4 = {x = 0, y = 1, t = {a = 3, b = 5}}
	local tab5 = {x = 0, y = 1, t = {a = 3, b = 4, c = 5}}

	unittest.assertTrue(utils.equals(tab1, tab2))
	unittest.assertFalse(utils.equals(tab1, tab3))
	unittest.assertFalse(utils.equals(tab1, tab4))
	unittest.assertFalse(utils.equals(tab1, tab5))

	unittest.assertFalse(utils.equals(num1, tab1))

end



function TestUtils:testClone()

	local num1 = 23
	local num2 = utils.clone(num1)
	local bool1 = true
	local bool2 = utils.clone(bool1)
	local string1 = 'hello'
	local string2 = utils.clone(string1)
	local fun1 = function() print('world') end
	local fun2 = utils.clone(fun1)
	local table1 = {
		x = 21, 
		flag = true, 
		tab = {
			str = 'Test!', 
			y = 3,
			fun = function() print('hello world!') end,
		},
	}
	local table2 = utils.clone(table1)

	unittest.assertEquals(num1, num2)
	unittest.assertEquals(bool1, bool2)
	unittest.assertEquals(string1, string2)
	unittest.assertEquals(fun1, fun2)
	unittest.assertEquals(table1, table2)

end



function TestUtils:testCopy()

	local num1 = 23
	local bool1 = true
	local func1 = function() print('hello world!') end
	local table1 = {
		x = 21, 
		flag = true, 
		tab = {
			str = 'Test!', 
			y = 3,
			fun = function() print('hello world!') end,
		},
	}

	local num2 = 0
	local bool2 = false
	local func2 = function() end
	local table2 = { 
		x = 0, 
		flag = false,
		tab = {
			str = 'Boo!',
			y = -3,
			fun = function() end,
		},
	}

	unittest.assertErrorMsgContains('Arguments must be of type \'table\'.', utils.copy, num2, num1)
	unittest.assertErrorMsgContains('Arguments must be of type \'table\'.', utils.copy, bool2, bool1)
	unittest.assertErrorMsgContains('Arguments must be of type \'table\'.', utils.copy, func2, func1)

	utils.copy(table2, table1)
	unittest.assertEquals(table2, table1)
	unittest.assertFalse(table2 == table1)

end