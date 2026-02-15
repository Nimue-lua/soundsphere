---@class yi.L
local L = {}

local current = {}

---@param t {[string]: string}
---Apply a table of translations to the current localization.
function L:apply(t)
	for k, v in pairs(t) do
		current[k] = v
	end
end

---@param key string
---@return string
---Get a localized string.
function L:get(key)
	return current[key] or key
end

setmetatable(L, {
	__index = function(_, key)
		return current[key] or key
	end
})

return L
