local Node = require("ui.view.Node")
local Label = require("ui.view.Label")
local Colors = require("yi.Colors")
local Resources = require("yi.Resources")

---@class yi.Slider : view.Node
---@overload fun(label: string, get_value: (fun(): number), set_value: fun(v: number), min: number, max: number, step: number): yi.Slider
local Slider = Node + {}

---@param label string
---@param get_value fun(): number
---@param set_value fun(v: number)
---@param min number
---@param max number
---@param step number
function Slider:new(label, get_value, set_value, min, max, step)
	Node.new(self)
	self.label = label
	self.get_value = get_value
	self.set_value = set_value
	self.min = min
	self.max = max
	self.step = step
	self.handles_mouse_input = true
	self.layout_box:setWidth(300)
	self.layout_box:setHeight(64)
	self.label_text = self:add(Label(Resources:newTextBatch("regular", 24, self.label)))
	self.value_text = self:add(Label(Resources:newTextBatch("regular", 16)))
	self.value_text:setPivot("center_right")
	self:updateValueLabel()
end

---@param e ui.DragStartEvent
function Slider:onDragStart(e)
	self:newPositionSet(e.x, e.y)
end

---@param e ui.DragEvent
function Slider:onDrag(e)
	self:newPositionSet(e.x, e.y)
end

---@param e ui.MouseClickEvent
function Slider:onMouseClick(e)
	self:newPositionSet(e.x, e.y)
end

---@param x number Global mouse coordinate
---@param y number Global mouse coordinate
function Slider:newPositionSet(x, y)
	local imx, _ = self.transform:get():inverseTransformPoint(x, y)
	local w = self:getCalculatedWidth()
	local percentage = math.max(0, math.min(1, imx / w))
	local val = self.min + (self.max - self.min) * percentage
	if self.step > 0 then
		val = math.floor(val / self.step + 0.5) * self.step
	end
	self.set_value(val)
	self:updateValueLabel()
end

function Slider:updateValueLabel()
	local val = tostring(self.get_value())
	local value_str = ""

	if self.step % 1 ~= 0 then
		value_str = ("%.2f"):format(val)
	else
		value_str = tostring(val)
	end

	self.value_text:setText(value_str)
end

function Slider:draw()
	local w = self:getCalculatedWidth()
	local h = self:getCalculatedHeight()

	local track_h = 4
	local track_y = h - 12
	local val = self.get_value()
	local percentage = (val - self.min) / (self.max - self.min)

	love.graphics.setColor(1, 1, 1, 0.15)
	love.graphics.rectangle("fill", 0, track_y - track_h / 2, w, track_h)

	love.graphics.setColor(Colors.accent)
	love.graphics.rectangle("fill", 0, track_y - track_h / 2, w * percentage, track_h)

	local handle_x = w * percentage
	local handle_w = 4
	local handle_h = 24
	love.graphics.setColor(Colors.text)
	love.graphics.rectangle("fill", handle_x - handle_w / 2, track_y - handle_h / 2, handle_w, handle_h)
end

return Slider
