local unittest = require 'hzi.unittest'
local scene = require 'hzi.scene'
local hmath = require 'hzi.math'
local class = require 'hzi.class'
local errors = require 'hzi.errors'



local SpecialNode = class.declare('SpecialNode', scene.Node)

function SpecialNode:new(arg)
	arg = arg or {}
	scene.Node.new(self, arg)
	self.value = 0
	self:addCallback('test', self._onTestMsg)
end

function SpecialNode:_onTestMsg(msg)
	self.value = 11
	return true
end

function SpecialNode:_onUpdate(dt)
	self.value = self.value + dt
end

function SpecialNode:_isDeletable()
	return self.value >= 4
end



TestNode = {}

function TestNode:testInstantiation()

	local n1 = scene.Node()
	local n2 = scene.Node({
		position = hmath.Vector2(1,2),
		rotation = 3,
		origin = hmath.Vector2(4,5),
		scale = hmath.Vector2(6,7),
		updating = false,
		visible = false,
		listening = false,
	})

	unittest.assertObjectEquals(n1:getPosition(), hmath.Vector2(0,0))
	unittest.assertEquals(n1:getRotation(), 0)
	unittest.assertObjectEquals(n1:getScale(), hmath.Vector2(1,1))
	unittest.assertObjectEquals(n1:getOrigin(), hmath.Vector2(0,0))
	unittest.assertTrue(n1:isUpdating())
	unittest.assertTrue(n1:isListening())
	unittest.assertTrue(n1:isVisible())

	unittest.assertObjectEquals(n2:getPosition(), hmath.Vector2(1,2))
	unittest.assertEquals(n2:getRotation(), 3)
	unittest.assertObjectEquals(n2:getScale(), hmath.Vector2(6,7))
	unittest.assertObjectEquals(n2:getOrigin(), hmath.Vector2(4,5))
	unittest.assertFalse(n2:isUpdating())
	unittest.assertFalse(n2:isListening())
	unittest.assertFalse(n2:isVisible())

end



function TestNode:testTransformations()

	local n = scene.Node()
	local t = hmath.Transform()

	n:setOrigin(3,4)
	t:setOrigin(3,4)
	unittest.assertObjectEquals(n:getOrigin(), t:getOrigin())

	n:setOrigin(hmath.Vector2(5,6))
	t:setOrigin(hmath.Vector2(5,6))
	unittest.assertObjectEquals(n:getOrigin(), t:getOrigin())

	n:moveOrigin(3,4)
	t:moveOrigin(3,4)
	unittest.assertObjectEquals(n:getOrigin(), t:getOrigin())

	n:moveOrigin(hmath.Vector2(5,6))
	t:moveOrigin(hmath.Vector2(5,6))
	unittest.assertObjectEquals(n:getOrigin(), t:getOrigin())

	n:setPosition(3,4)
	t:setPosition(3,4)
	unittest.assertObjectEquals(n:getPosition(), t:getPosition())

	n:setPosition(hmath.Vector2(5,6))
	t:setPosition(hmath.Vector2(5,6))
	unittest.assertObjectEquals(n:getPosition(), t:getPosition())

	n:translate(3,4)
	t:translate(3,4)
	unittest.assertObjectEquals(n:getPosition(), t:getPosition())

	n:translate(hmath.Vector2(5,6))
	t:translate(hmath.Vector2(5,6))
	unittest.assertObjectEquals(n:getPosition(), t:getPosition())

	n:setScale(3,4)
	t:setScale(3,4)
	unittest.assertObjectEquals(n:getScale(), t:getScale())

	n:setScale(hmath.Vector2(5,6))
	t:setScale(hmath.Vector2(5,6))
	unittest.assertObjectEquals(n:getScale(), t:getScale())

	n:scale(3,4)
	t:scale(3,4)
	unittest.assertObjectEquals(n:getScale(), t:getScale())

	n:scale(hmath.Vector2(5,6))
	t:scale(hmath.Vector2(5,6))
	unittest.assertObjectEquals(n:getScale(), t:getScale())

	n:setRotation(3)
	t:setRotation(3)
	unittest.assertObjectEquals(n:getRotation(), t:getRotation())

	n:rotate(2)
	t:rotate(2)
	unittest.assertObjectEquals(n:getRotation(), t:getRotation())

end



function TestNode:testChildrenAttachment()

	local n1 = scene.Node()
	local n2 = scene.Node()
	local n3 = scene.Node()
	local s1 = SpecialNode()

	n1:attachChild(n2)
	n1:attachChild(n3)
	n2:attachChild(s1)

	unittest.assertErrorMsgContains('\'attachChild\': cannot attach the node as a child of itself.', n1.attachChild, n1, n1)
	unittest.assertErrorMsgContains('\'attachChild\': child already has a parent.', n1.attachChild, n1, n2)
	unittest.assertErrorMsgContains(errors.badPolymorphicType(2, 'attachChild', scene.Node:type()), n1.attachChild, n1, {})

	unittest.assertNil(n1._parent)
	unittest.assertTrue(n2._parent == n1)
	unittest.assertTrue(n3._parent == n1)
	unittest.assertTrue(s1._parent == n2)
	unittest.assertEquals(n1._childrenIndexes[n2], 1)
	unittest.assertEquals(n1._childrenIndexes[n3], 2)
	unittest.assertEquals(n2._childrenIndexes[s1], 1)
	unittest.assertTrue(n1._children[1] == n2)
	unittest.assertTrue(n1._children[2] == n3)
	unittest.assertTrue(n2._children[1] == s1)

	n1:detachChild(n2)
	unittest.assertNil(n2._parent)
	unittest.assertNil(n1._childrenIndexes[n2])
	unittest.assertTrue(n1._children[1] == n3)
	unittest.assertNil(n1._children[2])

	unittest.assertErrorMsgContains('\'detachChild\': child not found.', n1.detachChild, n1, n2)
	unittest.assertErrorMsgContains('\'detachChild\': child not found.', n1.detachChild, n1, {})

end



function TestNode:testGlobalTransform()

	local n1 = scene.Node({
			position = hmath.Vector2(2,3),
			rotation = 0,
		})
	local n2 = scene.Node({
			position = hmath.Vector2(-1,1),
			rotation = 90,
		})
	local n3 = scene.Node({
			position = hmath.Vector2(3,5),
			rotation = 3,
		})
	local n4 = scene.Node({
			position = hmath.Vector2(-3,1),
			rotation = 30,
		})

	n1:attachChild(n2)
	n1:attachChild(n3)
	n2:attachChild(n4)

	unittest.assertEquals(n1:getGlobalRotation(), 0)
	unittest.assertEquals(n2:getGlobalRotation(), 90)
	unittest.assertEquals(n3:getGlobalRotation(), 3)
	unittest.assertEquals(n4:getGlobalRotation(), 120)

	unittest.assertObjectEquals(n1:getGlobalPosition(), hmath.Vector2(2,3))
	unittest.assertObjectEquals(n2:getGlobalPosition(), hmath.Vector2(1,4))
	unittest.assertObjectEquals(n3:getGlobalPosition(), hmath.Vector2(5,8))
	unittest.assertAlmostEquals(n4:getGlobalPosition().x , 0, 1e-16)
	unittest.assertAlmostEquals(n4:getGlobalPosition().y , 1, 1e-16)

	local t1 = hmath.Transform({
		position = hmath.Vector2(2,3),
		rotation = 0,
	})
	local t2 = hmath.Transform({
			position = hmath.Vector2(-1,1),
			rotation = 90,
		})
	local t3 = hmath.Transform({
			position = hmath.Vector2(3,5),
			rotation = 3,
		})
	local t4 = hmath.Transform({
			position = hmath.Vector2(-3,1),
			rotation = 30,
		})

	unittest.assertObjectEquals(n1:getGlobalTransformMatrix(), t1:getTransformMatrix())
	unittest.assertObjectEquals(n2:getGlobalTransformMatrix(), t1:getTransformMatrix() * t2:getTransformMatrix())
	unittest.assertObjectEquals(n3:getGlobalTransformMatrix(), t1:getTransformMatrix() * t3:getTransformMatrix())
	unittest.assertObjectEquals(n4:getGlobalTransformMatrix(), t1:getTransformMatrix() * t2:getTransformMatrix() * t4:getTransformMatrix())

end



function TestNode:testUpdate()

	local s1 = SpecialNode()
	local s2 = SpecialNode()
	local s3 = SpecialNode()
	local s4 = SpecialNode()

	s1:attachChild(s2)
	s1:attachChild(s3)
	s2:attachChild(s4)

	s1:update(2)

	unittest.assertEquals(s1.value, 2)
	unittest.assertEquals(s2.value, 2)
	unittest.assertEquals(s3.value, 2)
	unittest.assertEquals(s4.value, 2)

end



function TestNode:testDeletion()

	local n1 = scene.Node()
	local n2 = scene.Node()
	local n3 = scene.Node()
	local n4 = scene.Node()
	local s1 = SpecialNode()

	n1:attachChild(n2)
	n1:attachChild(n3)
	n2:attachChild(n4)
	n2:attachChild(s1)

	n3:delete()
	unittest.assertTrue(n3:isDeleted())

	unittest.assertFalse(s1:isDeleted())
	s1.value = 6
	unittest.assertTrue(s1:isDeleted())

	n1:removeDeletedChildren()
	unittest.assertNil(n1._childrenIndexes[n3])
	unittest.assertNil(n2._childrenIndexes[s1])

end



function TestNode:testState()

	local n1 = scene.Node()
	local n2 = scene.Node()
	local n3 = scene.Node()
	local n4 = scene.Node()

	n1:attachChild(n2)
	n1:attachChild(n3)
	n2:attachChild(n4)

	n1:setUpdating(false)
	unittest.assertFalse(n1:isUpdating())
	unittest.assertFalse(n2:isUpdating())
	unittest.assertFalse(n3:isUpdating())
	unittest.assertFalse(n4:isUpdating())

	n1:setUpdating(true)
	n2:setUpdating(false)
	unittest.assertTrue(n1:isUpdating())
	unittest.assertFalse(n2:isUpdating())
	unittest.assertTrue(n3:isUpdating())
	unittest.assertFalse(n4:isUpdating())

	n1:setListening(false)
	unittest.assertFalse(n1:isListening())
	unittest.assertFalse(n2:isListening())
	unittest.assertFalse(n3:isListening())
	unittest.assertFalse(n4:isListening())

	n1:setListening(true)
	n2:setListening(false)
	unittest.assertTrue(n1:isListening())
	unittest.assertFalse(n2:isListening())
	unittest.assertTrue(n3:isListening())
	unittest.assertFalse(n4:isListening())

	n1:setVisible(false)
	unittest.assertFalse(n1:isVisible())
	unittest.assertFalse(n2:isVisible())
	unittest.assertFalse(n3:isVisible())
	unittest.assertFalse(n4:isVisible())

	n1:setVisible(true)
	n2:setVisible(false)
	unittest.assertTrue(n1:isVisible())
	unittest.assertFalse(n2:isVisible())
	unittest.assertTrue(n3:isVisible())
	unittest.assertFalse(n4:isVisible())

end



function TestNode:testMessagePassing()

	local s1 = SpecialNode()
	local s2 = SpecialNode()
	local s3 = SpecialNode()
	local s4 = SpecialNode()

	s1:attachChild(s2)
	s1:attachChild(s3)
	s2:attachChild(s4)

	s1:handleMessage({tag = 'test'})

	unittest.assertEquals(s1.value, 0)
	unittest.assertEquals(s2.value, 0)
	unittest.assertEquals(s3.value, 11)
	unittest.assertEquals(s4.value, 0)

end

