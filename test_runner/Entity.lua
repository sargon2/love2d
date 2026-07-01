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
