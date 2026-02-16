local Node = require("ui.view.Node")
local Colors = require("yi.Colors")
local Resources = require("yi.Resources")

---@class yi.SongSelect.Cell : view.Node
---@operator call: yi.SongSelect.Cell
local Cell = Node + {}

---@param label string
function Cell:new(label)
	Node.new(self)
	self:setHeight(70)
	self:setWidth(140)
	self.top_text = Resources:newTextBatch("regular", 16, label)
	self.value_text = Resources:newTextBatch("bold", 36, "XXX")
end

function Cell:destroy()
	Node.destroy(self)
	self.top_text:release()
	self.value_text:release()
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
	love.graphics.draw(self.top_text.object)
	love.graphics.setColor(Colors.text)
	love.graphics.translate(0, 14)
	love.graphics.draw(self.value_text.object)
end

return Cell
