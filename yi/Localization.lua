---@class yi.Localization : {[string]: string}
local Localization = {}

local current = {}

---@param t {[string]: string}
---Apply a table of translations to the current localization.
function Localization:apply(t)
	for k, v in pairs(t) do
		current[k] = v
	end
end

---@param key string
---@return string
---Get a localized string.
function Localization:get(key)
	return current[key] or key
end

setmetatable(Localization, {
	__index = function(_, key)
		return current[key] or key
	end
})

return Localization
