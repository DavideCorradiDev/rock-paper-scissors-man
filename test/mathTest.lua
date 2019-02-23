local unittest = require 'hzi.unittest'
local hmath = require 'hzi.math'
local class = require 'hzi.class'



TestMathVector = {}



function TestMathVector:testInit()

	local v1 = hmath.Vector2()
	local v2 = hmath.Vector2(3, 5)

	unittest.assertEquals(v1.x, 0)
	unittest.assertEquals(v1.y, 0)
	unittest.assertEquals(v2.x, 3)
	unittest.assertEquals(v2.y, 5)

end



function TestMathVector:testSum()

	local v1 = hmath.Vector2(2, 7)
	local v2 = hmath.Vector2(3, 5)

	local v3 = v1 + v2
	unittest.assertEquals(v3.x, 5)
	unittest.assertEquals(v3.y, 12)

end



function TestMathVector:testDifference()

	local v1 = hmath.Vector2(2, 7)
	local v2 = hmath.Vector2(3, 5)

	local v3 = v1 - v2
	unittest.assertEquals(v3.x, -1)
	unittest.assertEquals(v3.y, 2)

	local v4 = v2 - v1
	unittest.assertEquals(v4.x, 1)
	unittest.assertEquals(v4.y, -2)

end



function TestMathVector:testMultiplication()

	local v1 = hmath.Vector2(2, -7)

	local v2 = 2 * v1
	unittest.assertEquals(v2.x, 4)
	unittest.assertEquals(v2.y, -14)

	local v3 = v1 * -3
	unittest.assertEquals(v3.x, -6)
	unittest.assertEquals(v3.y, 21)

	unittest.assertErrorMsgContains('One argument must be of type \'' .. hmath.Vector2.type() .. '\', one argument must be of type \'number\'', hmath.Vector2.__mul, v1, v2)

end



function TestMathVector:testMuDivision()

	local v1 = hmath.Vector2(2, -7)

	local v2 = v1 / 2
	unittest.assertEquals(v2.x, 1)
	unittest.assertEquals(v2.y, -3.5)

	unittest.assertErrorMsgContains('First argument must be of type \'' .. hmath.Vector2.type() .. '\', second argument must be of type \'number\'', hmath.Vector2.__div, 3, v1)

end



function TestMathVector:testEquality()

	local v1 = hmath.Vector2(3,5)
	local v2 = hmath.Vector2(3,5)
	local v3 = hmath.Vector2(5,3)
	local v4 = hmath.Vector2(7,2)

	unittest.assertObjectEquals(v1, v2)
	unittest.assertObjectNotEquals(v1, v3)
	unittest.assertObjectNotEquals(v1, v4)

end



function TestMathVector:testClone() 

	local v1 = hmath.Vector2(3,4)
	local v2 = v1:clone()
	local v3 = v1
	local v4 = hmath.Vector2()
	v4:copy(v1)
	v1.x = 5
	v1.y = 6

	unittest.assertEquals(v2.x, 3)
	unittest.assertEquals(v2.y, 4)
	unittest.assertEquals(v3.x, 5)
	unittest.assertEquals(v3.y, 6)
	unittest.assertEquals(v4.x, 3)
	unittest.assertEquals(v4.y, 4)

end



function TestMathVector:testNorm()

	local v1 = hmath.Vector2(3,4)
	local v2 = hmath.Vector2()
	local v3 = hmath.Vector2(7, 0)

	unittest.assertEquals(v1:squareNorm(), 25)
	unittest.assertEquals(v1:norm(), 5)
	unittest.assertEquals(v2:squareNorm(), 0)
	unittest.assertEquals(v2:norm(), 0)
	unittest.assertEquals(v3:squareNorm(), 49)
	unittest.assertEquals(v3:norm(), 7)

end



function TestMathVector:testNormalization()

	local v1 = hmath.Vector2()
	local v2 = hmath.Vector2(3,4)

	unittest.assertErrorMsgContains('Cannot normalize with norm equal to 0.', hmath.Vector2.normalize, v1)
	
	v2:normalize()
	unittest.assertEquals(v2:norm(), 1)

end



TestMathTransformMatrix = {}



function TestMathTransformMatrix:testClone() 

	local t1 = hmath.TransformMatrix(1,2,3,4,5,6,0,0,1)
	local t2 = t1
	local t3 = t1:clone()
	local t4 = t1:clone()
	local t5 = hmath.TransformMatrix()
	t5:copy(t1)

	unittest.assertObjectEquals(t1, t2)
	unittest.assertObjectEquals(t1, t3)
	unittest.assertObjectEquals(t1, t4)
	unittest.assertObjectEquals(t5, t1)

	t1._mat[3] = 9

	unittest.assertObjectEquals(t1, t2)
	unittest.assertObjectNotEquals(t1, t3)
	unittest.assertObjectNotEquals(t1, t4)
	unittest.assertObjectNotEquals(t5, t1)
	unittest.assertObjectEquals(t3, t4)
	unittest.assertObjectEquals(t5, t4)

end



function TestMathTransformMatrix:testEquals()

	local t1 = hmath.TransformMatrix(1,2,3,4,5,6,0,0,1)
	local t2 = t1
	local t3 = hmath.TransformMatrix(1,2,3,4,5,6,0,0,1)
	local t4 = hmath.TransformMatrix(4,5,6,7,8,9,0,0,1)

	unittest.assertObjectEquals(t1, t2)
	unittest.assertObjectEquals(t1, t3)
	unittest.assertObjectNotEquals(t1, t4)

end



function TestMathTransformMatrix:testInverse()

	local t1 = hmath.TransformMatrix(7,-8,9,-1,2,-3,0,0,1)
	local t2 = t1:getInverse()
	local t3 = hmath.TransformMatrix(1/3, 1 + 1/3, 1, 1/6, 1 + 1/6, 2, -0, -0, 1)

	unittest.assertObjectEquals(t2, t3)

	local t4 = hmath.TransformMatrix()
	unittest.assertErrorMsgContains('\'getInverse\': matrix determinant equal to 0, cannot invert.', hmath.TransformMatrix.getInverse, t4)

end



function TestMathTransformMatrix:testMultiplcation()

	local t1 = hmath.TransformMatrix(1,2,3,4,5,6,0,0,1)
	local t2 = hmath.TransformMatrix(7,-8,9,-1,2,-3,0,0,1)
	local t3 = hmath.TransformMatrix(5,-4,6,23,-22,27,0,0,1)
	local t4 = hmath.TransformMatrix.multiply(t1, t2)
	local t5 = t1 * t2

	unittest.assertObjectEquals(t3, t4)

	t1:combine(t2)

	unittest.assertObjectEquals(t3, t1)
	unittest.assertObjectEquals(t4, t1)
	unittest.assertObjectEquals(t5, t1)

end



function TestMathTransformMatrix:testTranslation()

	local t1 = hmath.TransformMatrix(7,-8,9,-1,2,-3,0,0,1)
	local t2 = hmath.TransformMatrix(7,-8,46,-1,2,-10,0,0,1)

	t1:translate(hmath.Vector2(3,-2))

	unittest.assertObjectEquals(t1, t2)

end



function TestMathTransformMatrix:testRotation()

	local t1 = hmath.TransformMatrix(7,-8,9,-1,2,-3,0,0,1)
	local t2 = hmath.TransformMatrix(7,-8,9,-1,2,-3,0,0,1)
	local t3 = hmath.TransformMatrix(-8,-7,9,2,1,-3,0,0,1)
	local t4 = hmath.TransformMatrix(8,7,-23,-2,-1,5,0,0,1)

	t1:rotate(90)
	t2:rotate(-90, hmath.Vector2(2,2))

	for i,v in ipairs(t1._mat) do
		unittest.assertAlmostEquals(t1._mat[i], t3._mat[i], 1e-16)
	end
	for i,v in ipairs(t2._mat) do
		unittest.assertAlmostEquals(t2._mat[i], t4._mat[i], 1e-16)
	end

end



function TestMathTransformMatrix:testScale()

	local t1 = hmath.TransformMatrix(7,-8,9,-1,2,-3,0,0,1)
	local t2 = hmath.TransformMatrix(7,-8,9,-1,2,-3,0,0,1)
	local t3 = hmath.TransformMatrix(21,-4,9,-3,1,-3,0,0,1)
	local t4 = hmath.TransformMatrix(21,-60,127,-3,15,-31,0,0,1)

	t1:scale(hmath.Vector2(3, 0.5))
	t2:scale(hmath.Vector2(3, 7.5), hmath.Vector2(-1, 2))

	unittest.assertObjectEquals(t1, t3)
	unittest.assertObjectEquals(t2, t4)

end




function TestMathTransformMatrix:testTransformPoint()

	local t1 = hmath.TransformMatrix(7,-8,9,-1,2,-3,0,0,1)
	local v1 = hmath.Vector2(-3, 7)
	local v2 = t1:transformPoint(v1)
	local v3 = hmath.Vector2(-68, 14)

	unittest.assertObjectEquals(v2, v3)

end




TestMathTransform = {}



function TestMathTransform:testInitialization()
	local t1 = hmath.Transform()
	local t2 = hmath.Transform({
		position = hmath.Vector2(2,3),
		rotation = 5,
		scale = hmath.Vector2(7,11),
		origin = hmath.Vector2(13,17),
	})

	unittest.assertObjectEquals(t1:getPosition(), hmath.Vector2())
	unittest.assertEquals(t1:getRotation(), 0)
	unittest.assertObjectEquals(t1:getScale(), hmath.Vector2(1,1))
	unittest.assertObjectEquals(t1:getOrigin(), hmath.Vector2())

	unittest.assertObjectEquals(t2:getPosition(), hmath.Vector2(2,3))
	unittest.assertEquals(t2:getRotation(), 5)
	unittest.assertObjectEquals(t2:getScale(), hmath.Vector2(7,11))
	unittest.assertObjectEquals(t2:getOrigin(), hmath.Vector2(13,17))

end



function TestMathTransform:testEquality()

	local t1 = hmath.Transform({
		position = hmath.Vector2(2,3),
		rotation = 5,
		scale = hmath.Vector2(7,11),
		origin = hmath.Vector2(13,17),
	})
	local t2 = t1:clone()
	local t3 = hmath.Transform()

	unittest.assertObjectEquals(t1, t2)
	unittest.assertObjectNotEquals(t1, t3)

	local tmat = t1:getTransformMatrix()
	unittest.assertObjectEquals(t1, t2)

end



function TestMathTransform:testPosition()

	local t1 = hmath.Transform()

	t1:setPosition(3,4)
	unittest.assertObjectEquals(t1:getPosition(), hmath.Vector2(3,4))

	t1:setPosition(hmath.Vector2(-1,3))
	unittest.assertObjectEquals(t1:getPosition(), hmath.Vector2(-1,3))

	t1:translate(1,-1)
	unittest.assertObjectEquals(t1:getPosition(), hmath.Vector2(0,2))

	t1:translate(hmath.Vector2(2,-3))
	unittest.assertObjectEquals(t1:getPosition(), hmath.Vector2(2,-1))

	unittest.assertErrorMsgContains('Invalid arguments.', t1.setPosition, t1)
	unittest.assertErrorMsgContains('Invalid arguments.', t1.translate, t1)

end



function TestMathTransform:testRotation()

	local t1 = hmath.Transform()

	t1:setRotation(30)
	unittest.assertTrue(class.equals(t1:getRotation(), 30))

	t1:rotate(15)
	unittest.assertEquals(t1:getRotation(), 45)

	unittest.assertErrorMsgContains('Invalid arguments.', t1.setRotation, t1)
	unittest.assertErrorMsgContains('Invalid arguments.', t1.rotate, t1)

end



function TestMathTransform:testScaling()

	local t1 = hmath.Transform()

	t1:setScale(3,4)
	unittest.assertObjectEquals(t1:getScale(), hmath.Vector2(3,4))

	t1:setScale(hmath.Vector2(-1,3))
	unittest.assertObjectEquals(t1:getScale(), hmath.Vector2(-1,3))

	t1:scale(1,-1)
	unittest.assertObjectEquals(t1:getScale(), hmath.Vector2(-1,-3))

	t1:scale(hmath.Vector2(2,-3))
	unittest.assertObjectEquals(t1:getScale(), hmath.Vector2(-2,9))

	unittest.assertErrorMsgContains('Invalid arguments.', t1.setScale, t1)
	unittest.assertErrorMsgContains('Invalid arguments.', t1.scale, t1)

end



function TestMathTransform.testOrigin()

	local t1 = hmath.Transform()

	t1:setOrigin(3,4)
	unittest.assertObjectEquals(t1:getOrigin(), hmath.Vector2(3,4))

	t1:setOrigin(hmath.Vector2(-1,3))
	unittest.assertObjectEquals(t1:getOrigin(), hmath.Vector2(-1,3))

	t1:moveOrigin(1,-1)
	unittest.assertObjectEquals(t1:getOrigin(), hmath.Vector2(0,2))

	t1:moveOrigin(hmath.Vector2(2,-3))
	unittest.assertObjectEquals(t1:getOrigin(), hmath.Vector2(2,-1))

	unittest.assertErrorMsgContains('Invalid arguments.', t1.setOrigin, t1)
	unittest.assertErrorMsgContains('Invalid arguments.', t1.moveOrigin, t1)

end



function TestMathTransform.testTransform()

	t1 = hmath.Transform()
	m1 = hmath.TransformMatrix(1,0,0,0,1,0,0,0,1)

	unittest.assertObjectEquals(t1:getTransformMatrix(), m1)

	t1:translate(2,3)
	m1:translate(hmath.Vector2(2,3))
	unittest.assertObjectEquals(t1:getTransformMatrix(), m1)

	t1:rotate(-90)
	m1:rotate(-90)
	unittest.assertObjectEquals(t1:getTransformMatrix(), m1)

	t1:scale(2,3)
	m1:scale(hmath.Vector2(2,3))
	unittest.assertObjectEquals(t1:getTransformMatrix(), m1)
	
	t1:setOrigin(-1,5)
	m1:translate(hmath.Vector2(1,-5))
	unittest.assertObjectEquals(t1:getTransformMatrix(), m1)

	unittest.assertObjectEquals(t1:getInverseTransformMatrix(), m1:getInverse())

end
