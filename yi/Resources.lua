---@class yi.Resources
---@field fonts {[string]: love.Font}
local Resources = {}

---@alias yi.FontName "regular" | "bold" | "black" | "icons"
---@alias yi.FontSize 16 | 24 | 36 | 46 | 58 | 72

---@param dpi number
function Resources:init(dpi)
	self.dpi = dpi

	self.font_paths = {
		regular = "yi/assets/MiSans-Regular.ttf",
		bold = "yi/assets/MiSans-Bold.ttf",
		black = "yi/assets/MiSans-Heavy.ttf",
		icons = "yi/assets/lucide.ttf"
	}

	self.images = {
		gradient = love.graphics.newImage("yi/assets/gradient.png"),
		chart_cell = love.graphics.newImage("yi/assets/chart_cell.png")
	}

	self.fonts = {}
end

---@param name yi.FontName
---@param size yi.FontSize
---@return love.Font
function Resources:getFont(name, size)
	---@cast name string
	---@cast size integer
	local key = name .. tostring(size)

	if not self.fonts[key] then
		local path = self.font_paths[name]
		local object = love.graphics.newFont(path, size, "normal", self.dpi)
		self.fonts[key] = object
	end

	return self.fonts[key]
end

return Resources
