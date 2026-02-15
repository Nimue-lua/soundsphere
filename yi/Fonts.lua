---@class yi.Fonts
local Fonts = {}

--[[
Hero / Title	72px
Heading L		58px
Heading M		46px
Heading S		36px
Body / Primary	24px
Utility / Small 16px
]]

Fonts.cache = {}
Fonts.DPI = 1

---@enum (key) yi.Fonts.Kinds 
Fonts.Paths = {
	regular = "yi/MiSans/MiSans-Regular.ttf",
	bold = "yi/MiSans/MiSans-Bold.ttf",
	black = "yi/MiSans/MiSans-Heavy.ttf",
}

---@param font_kind yi.Fonts.Kinds
---@param size integer
function Fonts:get(font_kind, size)
	assert(font_kind, "Expected font_kind, got nil")
	assert(size, "Expected size, got nil")
	local key = font_kind .. tostring(size)
	if self.cache[key] then
		return self.cache[key]
	end
	local font = love.graphics.newFont(self.Paths[font_kind], size, "normal", Fonts.DPI)
	print(("[FONT] Created %s %i"):format(font_kind, size))
	self.cache[key] = font
	return font
end

return Fonts
