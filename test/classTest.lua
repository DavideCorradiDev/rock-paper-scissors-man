local unittest = require 'hzi.unittest'
local class = require 'hzi.class'
require 'test.class.BaseClass1'
require 'test.class.BaseClass2'
require 'test.class.SimpleDerivedClass'
require 'test.class.MultipleDerivedClass'
require 'test.class.StaticClass'



TestClass = {}



function TestClass:testDefinition()

	local foo = class.declare('foo')

	unittest.assertNotNil(foo)
	unittest.assertStrContains(foo:type(), 'foo')
	unittest.assertStrContains(foo:type(), foo.type())
	unittest.assertTrue(foo:typeOf(foo))
	unittest.assertTrue(foo:typeOf('foo'))
	unittest.assertTrue(foo:typeOf(foo.type()))

	unittest.assertErrorMsgContains('Argument 1 must be of type string.', class.declare)

end



function TestClass:testTypeInfo()

	local bc1a = BaseClass1()
	local bc1b = BaseClass1(3)

	unittest.assertStrContains(bc1a:type(), BaseClass1.type())
	unittest.assertStrContains(bc1b:type(), BaseClass1.type())
	unittest.assertTrue(bc1a:typeOf(BaseClass1))
	unittest.assertTrue(bc1b:typeOf(BaseClass1))
	unittest.assertTrue(bc1a:typeOf(BaseClass1.type()))
	unittest.assertTrue(bc1b:typeOf(BaseClass1.type()))
	unittest.assertErrorMsgContains('Argument 1 must be of type string or table.', bc1a.typeOf, bc1a, nil)

	local sdc = SimpleDerivedClass()

	unittest.assertStrContains(sdc:type(), SimpleDerivedClass.type())
	unittest.assertTrue(sdc:typeOf(BaseClass1))
	unittest.assertFalse(sdc:typeOf(BaseClass2))
	unittest.assertTrue(sdc:typeOf(SimpleDerivedClass))
	unittest.assertFalse(sdc:typeOf(MultipleDerivedClass))

	local mdc = MultipleDerivedClass()

	unittest.assertStrContains(mdc:type(), MultipleDerivedClass.type())
	unittest.assertTrue(mdc:typeOf(BaseClass1))
	unittest.assertTrue(mdc:typeOf(BaseClass2))
	unittest.assertFalse(mdc:typeOf(SimpleDerivedClass))
	unittest.assertTrue(mdc:typeOf(MultipleDerivedClass))
	unittest.assertTrue(mdc:typeOf(BaseClass1.type()))
	unittest.assertTrue(mdc:typeOf(BaseClass2.type()))
	unittest.assertFalse(mdc:typeOf(SimpleDerivedClass.type()))
	unittest.assertTrue(mdc:typeOf(MultipleDerivedClass.type()))

end



function TestClass:testInstantiation()

	local bc1a = BaseClass1()
	local bc1b = BaseClass1(3)
	local bc1c = BaseClass1()
	local bc2a = BaseClass2()
	local bc2b = BaseClass2(4)

	unittest.assertEquals(BaseClass1:getValue(), 0)
	unittest.assertEquals(BaseClass2:getOtherValue(), 3)
	unittest.assertEquals(bc1a:getValue(), 0)
	unittest.assertEquals(bc1b:getValue(), 3)
	unittest.assertEquals(bc1c:getValue(), 0)
	unittest.assertEquals(bc2a:getOtherValue(), 3)
	unittest.assertEquals(bc2b:getOtherValue(), 4)

	bc1a:setValue(4)
	bc1b:setValue(5)
	bc1c.mValue1 = 7
	bc2a:setOtherValue(10)
	bc2b.mValue2 = 8

	unittest.assertEquals(BaseClass1:getValue(), 0)
	unittest.assertEquals(BaseClass2:getOtherValue(), 3)
	unittest.assertEquals(bc1a:getValue(), 4)
	unittest.assertEquals(bc1b:getValue(), 5)
	unittest.assertEquals(bc1c:getValue(), 7)
	unittest.assertEquals(bc2a:getOtherValue(), 10)
	unittest.assertEquals(bc2b:getOtherValue(), 8)

end



function TestClass:testSimpleInheritance()

	local bc1a = BaseClass1()
	local sdca = SimpleDerivedClass()
	local sdcb = SimpleDerivedClass(2, 7)

	unittest.assertEquals(BaseClass1:getValue(), 0)
	unittest.assertEquals(SimpleDerivedClass:getValue(), 5)
	unittest.assertEquals(bc1a:getValue(), 0)
	unittest.assertEquals(sdca:getValue(), 5)
	unittest.assertEquals(sdcb:getValue(), 9)

end



function TestClass:testMultipleInheritance()

	local mdca = MultipleDerivedClass()
	local mdcb = MultipleDerivedClass(3, 8)

	unittest.assertEquals(MultipleDerivedClass:getValue(), 0)
	unittest.assertEquals(mdca:getValue(), 0)
	unittest.assertEquals(mdcb:getValue(), 24)		

	mdca:setValue(3)
	mdcb:setOtherValue(2)

	unittest.assertEquals(MultipleDerivedClass:getValue(), 0)
	unittest.assertEquals(mdca:getValue(), 9)
	unittest.assertEquals(mdcb:getValue(), 6)	

end



function TestClass:testMultipleInheritanceOverloadError()
	local foo = class.declare('foo')
	function foo:print()
		print 'foo!'
	end

	local boo = class.declare('boo')
	function boo:print()
		print 'boo!'
	end

	unittest.assertErrorMsgContains('function print already defined in class boo, impossible to declare function print.', class.declare, 'fooboo', foo, boo)
end



function TestClass:testStaticClass()

	local instance = StaticClass(2)

	unittest.assertEquals(instance:getField(), 2)
	unittest.assertEquals(instance.getStaticField(), 0)
	unittest.assertEquals(StaticClass:getField(), 0)
	unittest.assertEquals(StaticClass.getStaticField(), 0)

	instance:setField(11)
	unittest.assertEquals(instance:getField(), 11)
	unittest.assertEquals(instance.getStaticField(), 0)
	unittest.assertEquals(StaticClass:getField(), 0)
	unittest.assertEquals(StaticClass.getStaticField(), 0)

	StaticClass.setStaticField(23)
	unittest.assertEquals(instance:getField(), 11)
	unittest.assertEquals(instance.getStaticField(), 23)
	unittest.assertEquals(StaticClass:getField(), 0)
	unittest.assertEquals(StaticClass.getStaticField(), 23)

	instance.setStaticField(54)
	unittest.assertEquals(instance:getField(), 11)
	unittest.assertEquals(instance.getStaticField(), 54)
	unittest.assertEquals(StaticClass:getField(), 0)
	unittest.assertEquals(StaticClass.getStaticField(), 54)
end



function TestClass:testType()

	local n = 2
	local s = 'hello'
	local b = true
	local f = function() end
	local t = {x = 0, y = 1}
	local o = BaseClass1()

	unittest.assertEquals(class.type(n), 'number')
	unittest.assertEquals(class.type(s), 'string')
	unittest.assertEquals(class.type(b), 'boolean')
	unittest.assertEquals(class.type(f), 'function')
	unittest.assertEquals(class.type(t), 'table')
	unittest.assertEquals(class.type(o), BaseClass1:type())
	unittest.assertEquals(class.type(a), 'nil')

end



function TestClass:testEquals()

	local n1 = 2
	local n2 = 2
	local n3 = 3
	local s1 = 'hello'
	local s2 = 'hello'
	local s3 = 'world'
	local b1 = true
	local b2 = true
	local b3 = false
	local f1 = function() end
	local f2 = f1
	local f3 = function() end
	local t1 = {x = 0, y = 1}
	local t2 = {x = 0, y = 1}
	local t3 = {}
	local t4 = t1
	local o1 = BaseClass1()
	local o2 = BaseClass1()
	local o3 = BaseClass1(1)
	local o4 = o1
	local o5 = o1:clone()
	local o6 = BaseClass2()

	unittest.assertTrue(class.equals(n1, n2))
	unittest.assertFalse(class.equals(n1, n3))
	unittest.assertFalse(class.equals(n1, s1))
	unittest.assertTrue(class.equals(s1, s2))
	unittest.assertFalse(class.equals(s1, s3))
	unittest.assertFalse(class.equals(s1, b1))
	unittest.assertTrue(class.equals(b1, b2))
	unittest.assertFalse(class.equals(b1, b3))
	unittest.assertFalse(class.equals(b1, f1))
	unittest.assertTrue(class.equals(f1, f2))
	unittest.assertFalse(class.equals(f1, f3))
	unittest.assertFalse(class.equals(f1, t1))
	unittest.assertTrue(class.equals(t1, t2))
	unittest.assertFalse(class.equals(t1, t3))
	unittest.assertTrue(class.equals(t1, t4))
	unittest.assertFalse(class.equals(t1, o1))

	unittest.assertTrue(class.equals(o1, o2))
	unittest.assertFalse(class.equals(o1, o3))
	unittest.assertTrue(class.equals(o1, o4))
	unittest.assertTrue(class.equals(o1, o5))
	unittest.assertFalse(class.equals(o1, o6))
	unittest.assertFalse(class.equals(o1, n1))

end



function TestClass:testClone()

	local n1 = 1
	local n2 = class.clone(n1)
	local s1 = 'hello'
	local s2 = class.clone(s1)
	local b1 = true
	local b2 = class.clone(b1)
	local f1 = function() end
	local f2 = class.clone(f1)
	local t1 = {x = 0, y = 1}
	local t2 = class.clone(t1)
	local o1 = BaseClass1(3)
	local o2 = class.clone(o1)

	unittest.assertObjectEquals(n1, n2)
	unittest.assertObjectEquals(s1, s2)
	unittest.assertObjectEquals(b1, b2)
	unittest.assertObjectEquals(f1, f2)
	unittest.assertObjectEquals(t1, t2)
	unittest.assertFalse(t1 == t2)
	unittest.assertObjectEquals(o1, o2)
	unittest.assertFalse(o1 == o2)

end



function TestClass:testCopy()

	local n1 = 2
	local n2 = 0
	local t1 = {x = 0, y = 2}
	local t2 = {}
	local o1 = BaseClass1(4)
	local o2 = BaseClass1(3)
	local o3 = SimpleDerivedClass()

	unittest.assertErrorMsgContains('Arguments must be of type \'table\'.', class.copy, n1, n2)
	unittest.assertErrorMsgContains('Invalid copy. Argument 1 is of type \'' .. o2:type() .. '\', argument 2 is of type \'' .. o3:type() .. '\'.', class.copy, o2, o3)

	class.copy(t2, t1)
	class.copy(o2, o1)

	unittest.assertObjectEquals(t2, t1)
	unittest.assertObjectEquals(o2, o1)
	unittest.assertFalse(t1 == t2)
	unittest.assertFalse(o1 == o2)

end



function TestClass:testTypeOf()

	local n = 2
	local s = 'hello'
	local b = true
	local f = function() end
	local t = {x = 0, y = 1}
	local o = BaseClass1()
	local d = MultipleDerivedClass()

	unittest.assertTrue(class.typeOf(n, 'number'))
	unittest.assertFalse(class.typeOf(n, 'string'))
	unittest.assertTrue(class.typeOf(s, 'string'))
	unittest.assertFalse(class.typeOf(s, BaseClass1.type()))
	unittest.assertTrue(class.typeOf(b, 'boolean'))
	unittest.assertFalse(class.typeOf(b, 'number'))
	unittest.assertTrue(class.typeOf(f, 'function'))
	unittest.assertFalse(class.typeOf(f, 'table'))
	unittest.assertTrue(class.typeOf(t, 'table'))
	unittest.assertFalse(class.typeOf(t, MultipleDerivedClass.type()))

	unittest.assertTrue(class.typeOf(o, BaseClass1.type()))
	unittest.assertFalse(class.typeOf(o, MultipleDerivedClass.type()))
	unittest.assertTrue(class.typeOf(d, BaseClass1.type()))
	unittest.assertTrue(class.typeOf(d, MultipleDerivedClass.type()))

end