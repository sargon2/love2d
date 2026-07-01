lu = require('lib.luaunit.luaunit')
require('Entity')
require('Component')

function testBasicPass()
    lu.assertEquals(1,1)
end

function testUnusedIDIsNotAlive()
	local unused_id = 2834957234957 -- any number unlikely to be reached during testing
	lu.assertFalse(isAlive(packEntityId(unused_id, 0)))
	lu.assertFalse(isAlive(packEntityId(unused_id, 1)))
	lu.assertFalse(isAlive(packEntityId(unused_id, 2)))
	lu.assertFalse(isAlive(packEntityId(unused_id, 3)))
	lu.assertFalse(isAlive(packEntityId(unused_id, 4)))
	lu.assertFalse(isAlive(packEntityId(unused_id, 5)))
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

function testEntityReuse()
	local ent_id = createEntity()
	local id, gen = unpackEntityId(ent_id)

	destroyEntity(ent_id)
	local ent_id2 = createEntity()
	local id2, gen2 = unpackEntityId(ent_id2)
	lu.assertEquals(id, id2)
	lu.assertEquals(gen+1, gen2)
end

function testAssignDefaultPositionToEntity()
	local ent_id = createEntity()
	addComponentToEntity(ent_id, "Position")
	for eid, _ in getAllEntitiesWithComponent("Position") do
		if eid == ent_id then
			return
		end
	end
	lu.fail("eid not found")
end

function testAssignPositionToEntity()
	local ent_id = createEntity()
	addComponentToEntity(ent_id, "Position", {x = 3, y = 4})
	for eid, data in getAllEntitiesWithComponent("Position") do
		if eid == ent_id then
			lu.assertEquals(3, data["x"])
			lu.assertEquals(4, data["y"])
			return
		end
	end
	lu.fail("eid not found")
end

-- We have to have at least one command line argument for test discovery to work, because of how love2d invokes lua.
os.exit(lu.LuaUnit.run('-v', '--output', 'text'))