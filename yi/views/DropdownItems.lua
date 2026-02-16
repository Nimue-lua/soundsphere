local Node = require("ui.view.Node")
local Colors = require("yi.Colors")
local Resources = require("yi.Resources")

---@class yi.DropdownItems : view.Node
---@overload fun(items: string[], get_value: (fun(): number), set_value: fun(v: number), dropdown: yi.Dropdown): yi.DropdownItems
local DropdownItems = Node + {}

---@param items string[]
---@param get_value fun(): number
---@param set_value fun(v: number)
---@param dropdown yi.Dropdown
function DropdownItems:new(items, get_value, set_value, dropdown)
	Node.new(self)
	self.items = items
	self.get_value = get_value
	self.set_value = set_value
	self.dropdown = dropdown
	self.handles_mouse_input = true
	self.item_height = 32
	self.layout_box:setWidth(300)
	self.layout_box:setHeight(self.item_height * #items)
	self:setOrigin("top_left")
	self:setAnchor("bottom_left")
	self:disable()
end

function DropdownItems:load()
	self.font = Resources:getFont("regular", 24)
end

---@param e ui.MouseClickEvent
function DropdownItems:onMouseClick(e)
	local imx, imy = self.transform:get():inverseTransformPoint(e.x, e.y)
	local item_index = math.floor(imy / self.item_height) + 1

	if item_index >= 1 and item_index <= #self.items then
		self.set_value(item_index)
		self.dropdown:updateValueLabel()
		self.dropdown:close()
		return true
	end
end

function DropdownItems:draw()
	local w = self:getCalculatedWidth()
	local h = self:getCalculatedHeight()
	local current_value = self.get_value()

	love.graphics.setColor(Colors.button)
	love.graphics.rectangle("fill", 0, 0, w, h)

	love.graphics.setColor(Colors.outline)
	love.graphics.setLineWidth(1)
	love.graphics.rectangle("line", 0, 0, w, h)

	love.graphics.setFont(self.font.object)
	for i, item in ipairs(self.items) do
		local y = (i - 1) * self.item_height

		if i == current_value then
			love.graphics.setColor(Colors.accent)
			love.graphics.rectangle("fill", 0, y, w, self.item_height)
		end

		love.graphics.setColor(Colors.text)
		love.graphics.print(item, 12, y + (self.item_height - self.font.object:getHeight()) / 2)

		if i < #self.items then
			love.graphics.setColor(Colors.outline)
			love.graphics.line(0, y + self.item_height, w, y + self.item_height)
		end
	end
end

return DropdownItems
