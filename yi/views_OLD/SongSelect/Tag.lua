local Node = require("ui.view.Node")
local Label = require("ui.view.Label")
local Resources = require("yi.Resources")
local Colors = require("yi.Colors")

---@class yi.SongSelect.Tag : view.Node
---@operator call: yi.SongSelect.Tag
local Tag = Node + {}

function Tag:load()
	Node.load(self)
	self.background_color = Colors.panels
	self:setPaddings({5, 20, 5, 20})

	self.label = self:add(Label(Resources:newTextBatch("bold", 16, "LOADING...")))
	self.label.color = Colors.text
end

---@param v string
function Tag:setText(v)
	self.label:setText(v)
end

---@param v ui.Color
function Tag:setBackgroundColor(v)
	self.background_color = v
end

---@param v ui.Color
function Tag:setTextColor(v)
	self.label.color = v
end

function Tag:draw()
	local w, h = self:getCalculatedWidth(), self:getCalculatedHeight()
	love.graphics.setColor(self.background_color)
	love.graphics.rectangle("fill", 0, 0, w, h)
	love.graphics.setColor(Colors.outline)
	love.graphics.setLineWidth(1)
	love.graphics.rectangle("line", 0, 0, w, h)
end

return Tag
