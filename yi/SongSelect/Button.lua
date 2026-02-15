local Node = require("ui.view.Node")
local Colors = require("yi.Colors")

---@class yi.Button : view.Node
---@overload fun(callback: function): yi.Button
local Button = Node + {}

---@param callback function
function Button:new(callback)
	Node.new(self)
	self:setPaddings({2, 10, 2, 10})
	self.callback = callback
	self.handles_mouse_input = true
end

---@param e ui.MouseDownEvent
function Button:onMouseDown(e)
	self.callback()
	return true
end

function Button:draw()
	if self.mouse_over then
		love.graphics.setColor(Colors.button_hover)
	else
		love.graphics.setColor(Colors.button)
	end
	love.graphics.rectangle("fill", 0, 0, self:getCalculatedWidth(), self:getCalculatedHeight())
	love.graphics.setColor(Colors.button_text)
end

return Button
