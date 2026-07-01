
require('ComponentDefs')

components = {} -- key: entity id, value: component data

function addComponentToEntity(ent_id, componentName, data)
	if components[componentName] == nil then
		components[componentName] = {}
	end
	components[componentName][ent_id] = ComponentDefs[componentName].create(data)
end

function getAllEntitiesWithComponent(componentName)
	local comps = components[componentName]

	if type(comps) ~= "table" then
		return function() end
	end

	return next, comps
end