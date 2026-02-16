local FontRef = require("ui.FontRef")
local TextBatchRef = require("ui.TextBatchRef")

---@class yi.Resources
---@field font_refs {[string]: ui.FontRef}
---@field text_batch_refs {[ui.TextBatchRef]: ui.FontRef}
local Resources = {}

---@alias yi.FontName "regular" | "bold" | "black" | "icons"
---@alias yi.FontSize 16 | 24 | 36 | 46 | 58 | 72

function Resources:init()
	self.dpi = 1

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

	self.font_refs = {}
	self.text_batch_refs = setmetatable({}, {__mode = "kv"})
end

---@param name yi.FontName
---@param size yi.FontSize
---@return ui.FontRef
function Resources:getFont(name, size)
	---@cast name string
	---@cast size integer
	local key = name .. tostring(size)

	if self.font_refs[key] then
		return self.font_refs[key]
	end

	local path = self.font_paths[name]
	local object = love.graphics.newFont(path, size, "normal", self.dpi)
	self.font_refs[key] = FontRef(object, path, size)

	return self.font_refs[key]
end

---@param name yi.FontName
---@param size yi.FontSize
---@param text string?
function Resources:newTextBatch(name, size, text)
	local font_ref = self:getFont(name, size)
	local text_batch = love.graphics.newText(font_ref:get(), text)
	local text_batch_ref = TextBatchRef(text_batch)
	self.text_batch_refs[text_batch_ref] = font_ref
	return text_batch_ref
end

---@param dpi number
function Resources:setDpi(dpi)
	self.dpi = dpi

	for k, font in pairs(self.font_refs) do
		if font:isReleased() then
			self.font_refs[k] = nil
		else
			local object = love.graphics.newFont(font.path, font.size, "normal", self.dpi)
			font:replaceFont(object)
		end
	end

	for text_batch, font in pairs(self.text_batch_refs) do
		if text_batch:isReleased() then
			self.text_batch_refs[text_batch] = nil
		else
			text_batch.object:setFont(font.object)
		end
	end
end

return Resources
