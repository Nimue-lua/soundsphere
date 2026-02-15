local Node = require("ui.view.Node")
local Text = require("ui.view.Text")
local Fonts = require("yi.Fonts")

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
	self.text_obj = Text(Fonts:get("regular", 24), label)
	self.get_value = get_value
	self.set_value = set_value
	self.min = min
	self.max = max
	self.step = step

	self.handles_mouse_input = true

	self.layout_box:setWidth(300)
	self.layout_box:setHeight(64)
end

function Slider:load() end

---@param e ui.DragStartEvent
function Slider:onDragStart(e)
	self:onDrag(e)
end

---@param e ui.DragEvent
function Slider:onDrag(e)
	local imx, imy = self.transform:get():inverseTransformPoint(e.x, e.y)
	local w = self:getCalculatedWidth()
	local percentage = math.max(0, math.min(1, imx / w))
	local val = self.min + (self.max - self.min) * percentage
	if self.step > 0 then
		val = math.floor(val / self.step + 0.5) * self.step
	end
	self.set_value(val)
end

---@param e ui.DragEndEvent
function Slider:onDragEnd(e) end

---@param e ui.MouseClickEvent
function Slider:onMouseClick(e)
	self:onDrag(e)
end

function Slider:draw()
	local w = self:getCalculatedWidth()
	local h = self:getCalculatedHeight()

	love.graphics.setColor(1, 1, 1, 0.7)
	self.text_obj:draw()

	local track_h = 4
	local track_y = h - 12
	local val = self.get_value()
	local percentage = (val - self.min) / (self.max - self.min)

	love.graphics.setColor(1, 1, 1, 0.15)
	love.graphics.rectangle("fill", 0, track_y - track_h / 2, w, track_h)

	love.graphics.setColor(1, 1, 1, 0.8)
	love.graphics.rectangle("fill", 0, track_y - track_h / 2, w * percentage, track_h)

	local handle_x = w * percentage
	local handle_w = 4
	local handle_h = 24
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("fill", handle_x - handle_w / 2, track_y - handle_h / 2, handle_w, handle_h)

	local value_str = tostring(val)
	if self.step % 1 ~= 0 then
		value_str = string.format("%.2f", val)
	end

	local font = Fonts:get("regular", 16)
	love.graphics.setFont(font)
	love.graphics.setColor(1, 1, 1, 0.5)
	love.graphics.printf(value_str, 0, track_y - 28, w, "right")
end

return Slider
