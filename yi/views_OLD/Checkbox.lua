local Node = require("ui.view.Node")
local Label = require("ui.view.Label")
local Colors = require("yi.Colors")
local Resources = require("yi.Resources")

---@class yi.Checkbox : view.Node
---@overload fun(label: string, get_value: (fun(): boolean), set_value: fun(v: boolean)): yi.Checkbox
local Checkbox = Node + {}

---@param label string
---@param get_value fun(): boolean
---@param set_value fun(v: boolean)
function Checkbox:new(label, get_value, set_value)
	Node.new(self)
	self.get_value = get_value
	self.set_value = set_value
	self.handles_mouse_input = true
	self.layout_box:setWidth(300)
	self.layout_box:setHeight(40)
	self:add(Label(Resources:newTextBatch("regular", 24, label)))
end

---@param _ ui.MouseClickEvent
function Checkbox:onMouseClick(_)
	self.set_value(not self.get_value())
end

function Checkbox:draw()
	local w = self:getCalculatedWidth()
	local h = self:getCalculatedHeight()

	local box_size = 24
	local box_x = w - box_size
	local box_y = (h - box_size) / 2

	love.graphics.setColor(1, 1, 1, 0.15)
	love.graphics.rectangle("fill", box_x, box_y, box_size, box_size)

	love.graphics.setColor(Colors.outline)
	love.graphics.setLineWidth(1)
	love.graphics.rectangle("line", box_x, box_y, box_size, box_size)

	if self.get_value() then
		love.graphics.setColor(Colors.accent)
		local inset = 4
		love.graphics.rectangle("fill", box_x + inset, box_y + inset, box_size - inset * 2, box_size - inset * 2)
	end
end

return Checkbox
