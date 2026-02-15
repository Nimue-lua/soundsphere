require("table.clear")

-- Temporary tables
local params = {} -- Mixed styles and props

---@param n table?
---@return boolean
local function isNode(n)
	if n == nil then
		return false
	end
	if type(n) == "table" and n.updateTreeTransform then
		return true
	end
	return false
end

---@alias yi.Thing {[1]: view.Node, [string]: any, [integer]: yi.Thing | {[string]: any} }

---@param target view.Node
---@param thing yi.Thing
---@param ids {[string]: view.Node}
local function add_to(target, thing, ids)
	local instance = thing[1]
	target:add(instance)

	table.clear(params)

	for k, v in pairs(thing) do
		if type(k) == "string" then
			params[k] = v
		elseif type(v) == "table" and not getmetatable(v) and not isNode(v[1]) then
			for k2, v2 in pairs(v) do
				params[k2] = v2
			end
		end
	end

	instance:setup(params)

	if instance.id then
		ids[instance.id] = instance
	end

	for _, v in ipairs(thing) do
		if type(v) == "table" and isNode(v[1]) then
			---@cast v yi.Thing
			add_to(instance, v, ids)
		end
	end
end

---@param target view.Node
---@param things yi.Thing[]
---@return {[string]: view.Node}
local function build(target, things)
	local ids = {}
	for _, v in ipairs(things) do
		add_to(target, v, ids)
	end
	return ids
end

return build
