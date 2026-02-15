local Node = require("ui.view.Node")
local Text = require("ui.view.Text")
local Fonts = require("yi.Fonts")
local Colors = require("yi.Colors")

---@class yi.SongSelect.Cell : view.Node
---@operator call: yi.SongSelect.Cell
local Cell = Node + {}

---@param label string
function Cell:new(label)
	Node.new(self)
	self:setHeight(70)
	self:setWidth(140)
	self.top_text = Text(Fonts:get("regular", 16), label)
	self.value_text = Text(Fonts:get("bold", 36), "XXX")
end

---@param v string
function Cell:setValueText(v)
	self.value_text:setText(v)
end

function Cell:draw()
	local w, h = self:getCalculatedWidth(), self:getCalculatedHeight()
	love.graphics.setColor(Colors.panels)
	love.graphics.rectangle("fill", 0, 0, w, h)
	love.graphics.setColor(Colors.accent)
	love.graphics.setLineWidth(4)
	love.graphics.line(2, 0, 2, h)
	love.graphics.setColor(Colors.lines)
	love.graphics.translate(15, 5)
	self.top_text:draw()
	love.graphics.setColor(Colors.text)
	love.graphics.translate(0, 14)
	self.value_text:draw()
end

return Cell
