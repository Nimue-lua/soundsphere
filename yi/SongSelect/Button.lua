local Node = require("ui.view.Node")
local Text = require("ui.view.Text")
local Colors = require("yi.Colors")

---@class yi.Button : view.Node
---@overload fun(callback: function): yi.Button
local Button = Node + {}

local padding_x = 10

---@param callback function
---@param text_obj view.Text
---@param grow boolean?
function Button:new(callback, text_obj, grow)
	Node.new(self)
	self.callback = callback
	self.text_obj = text_obj
	if grow then
		self:setGrow(1)
	else
		self:setWidth(self.text_obj.width + padding_x)
	end
	self:setHeight(self.text_obj.height)
	self.handles_mouse_input = true
end

---@param e ui.MouseDownEvent
function Button:onMouseDown(e)
	self.callback()
	return true
end

function Button:draw()
	if self.mouse_over then
		love.graphics.setColor(0.2, 0.2, 0.3)
	else
		love.graphics.setColor(Colors.panels)
	end
	love.graphics.rectangle("fill", 0, 0, self:getCalculatedWidth(), self:getCalculatedHeight())
	love.graphics.setColor(1, 1, 1)

	local tx = (self:getCalculatedWidth() - self.text_obj.width) / 2
	local ty = (self:getCalculatedHeight() - self.text_obj.height) / 2
	love.graphics.translate(tx, ty)
	self.text_obj:draw()
end

return Button
