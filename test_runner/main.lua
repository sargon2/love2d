lu = require('lib.luaunit.luaunit')

local curr_ent_id = -1
local is_alive = {}

function createEntity()
	curr_ent_id = curr_ent_id + 1
	is_alive[curr_ent_id] = true
	return curr_ent_id
end

function isAlive(ent_id)
	return is_alive[ent_id] == true
end

function destroyEntity(ent_id)
	is_alive[ent_id] = false
end

function testBasicPass()
    lu.assertEquals(1,1)
end

function testSingleEntityLiveness()
	local ent_id = createEntity()
	lu.assertTrue(isAlive(ent_id))
	destroyEntity(ent_id)
	lu.assertFalse(isAlive(ent_id))
end

function testTwoEntityLiveness()
	local ent_id1 = createEntity()
	local ent_id2 = createEntity()
	lu.assertTrue(isAlive(ent_id1))
	lu.assertTrue(isAlive(ent_id2))
	destroyEntity(ent_id1)
	lu.assertFalse(isAlive(ent_id1))
	lu.assertTrue(isAlive(ent_id2))
	destroyEntity(ent_id2)
	lu.assertFalse(isAlive(ent_id1))
	lu.assertFalse(isAlive(ent_id2))
end

function testTwoEntityLivenessOtherWay()
	local ent_id1 = createEntity()
	local ent_id2 = createEntity()
	lu.assertTrue(isAlive(ent_id1))
	lu.assertTrue(isAlive(ent_id2))
	destroyEntity(ent_id2)
	lu.assertTrue(isAlive(ent_id1))
	lu.assertFalse(isAlive(ent_id2))
	destroyEntity(ent_id1)
	lu.assertFalse(isAlive(ent_id1))
	lu.assertFalse(isAlive(ent_id2))
end

-- We have to have at least one command line argument for test discovery to work, because of how love2d invokes lua.
os.exit(lu.LuaUnit.run('--output', 'text'))