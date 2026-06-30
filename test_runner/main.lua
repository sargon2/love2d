lu = require('lib.luaunit.luaunit')

local curr_ent_seq = -1
local gen = {}
local free = {}

function createEntity()
	if #free > 0 then
		local seq = table.remove(free)
		return packEntityId(seq, gen[seq])
	end
	curr_ent_seq = curr_ent_seq + 1
	gen[curr_ent_seq] = 0
	return packEntityId(curr_ent_seq, 0)
end

function isAlive(ent_id)
	seq, input_gen = unpackEntityId(ent_id)
	return gen[seq] == input_gen
end

function destroyEntity(ent_id)
	if(not isAlive(ent_id)) then return end
	
	seq, curr_gen = unpackEntityId(ent_id)
	
	-- increment generation
	curr_gen = curr_gen + 1
	gen[seq] = curr_gen
	
	-- add to free
	table.insert(free, seq)
end

function packEntityId(seq, gen)
	return {seq, gen}
end

function unpackEntityId(ent_id)
	return unpack(ent_id)
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

function testEntityReuse()
	local ent_id = createEntity()
	local id, gen = unpackEntityId(ent_id)

	destroyEntity(ent_id)
	local ent_id2 = createEntity()
	local id2, gen2 = unpackEntityId(ent_id2)
	lu.assertEquals(id, id2)
	lu.assertEquals(gen+1, gen2)
end

-- We have to have at least one command line argument for test discovery to work, because of how love2d invokes lua.
os.exit(lu.LuaUnit.run('-v', '--output', 'text'))