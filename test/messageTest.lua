local unittest = require 'hzi.unittest'
local msg = require 'hzi.message'



TestMessageHandler = {}


function TestMessageHandler:testAddRemoveCallback()

	local mh = msg.MessageHandler()

	mh:addCallback('m1', function(self, msg) end)
	mh:addCallback('m2', function(self, msg) end)

	unittest.assertEquals(type(mh._callbacks['m1']), 'function')
	unittest.assertEquals(type(mh._callbacks['m2']), 'function')

	mh:removeCallback('m1')
	unittest.assertEquals(type(mh._callbacks['m1']), 'nil')
	unittest.assertEquals(type(mh._callbacks['m2']), 'function')

end



function TestMessageHandler:testHandleMessage()

	local mh = msg.MessageHandler()
	local n1 = 0
	local testval = false

	mh:addCallback('m1', function(self, msg) 
			n1 = n1 + msg.x
			return true
		end
	)
	mh:addCallback('m2', function(self, msg) 
			n1 = msg.x
			return true
		end
	)

	testval = mh:handleMessage({tag = 'm1', x = 2})
	unittest.assertTrue(testval)

	testval = mh:handleMessage({tag = 'm1', x = 3})
	unittest.assertTrue(testval)

	unittest.assertEquals(n1, 5)

	testval = mh:handleMessage({tag = 'm2', x = 7})
	unittest.assertTrue(testval)

	unittest.assertEquals(n1, 7)

	testval = mh:handleMessage({tag = 'm3', x = 3, y = 7})
	unittest.assertFalse(testval)

	unittest.assertErrorMsgContains('bad argument # 2 to \'handleMessage\' (table expected, got nil)', mh.handleMessage, self)

end



TestMessageQueue = {}



function TestMessageQueue:testAll()

	local mq = msg.MessageQueue()
	local msg

	unittest.assertTrue(mq:isEmpty())

	mq:pushMessage({tag = 'm1'})
	mq:pushMessage({tag = 'm2'})
	mq:pushMessage({tag = 'm3'})

	unittest.assertFalse(mq:isEmpty())

	msg = mq:popMessage()
	unittest.assertEquals(msg.tag, 'm1')

	msg = mq:popMessage()
	unittest.assertEquals(msg.tag, 'm2')

	msg = mq:popMessage()
	unittest.assertEquals(msg.tag, 'm3')

	unittest.assertTrue(mq:isEmpty())

	msg = mq:popMessage()
	unittest.assertEquals(msg, nil)

	unittest.assertErrorMsgContains('bad argument # 2 to \'pushMessage\' (table expected, got number)', mq.pushMessage, mq, 2)

end