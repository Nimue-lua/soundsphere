local Node = require("ui.view.Node")
local Label = require("ui.view.Label")
local Colors = require("yi.Colors")
local Resources = require("yi.Resources")
local DropdownItems = require("yi.views.DropdownItems")

---@class yi.Dropdown : view.Node
---@overload fun(label: string, items: string[], get_value: fun(): number, set_value: fun(v: number)): yi.Dropdown
local Dropdown = Node + {}

local LABEL_HEIGHT = 28
local LABEL_GAP = 8
local ITEM_INSET = 8
local BOX_HEIGHT = 40

---@param label string
---@param items string[]
---@param get_value fun(): number
---@param set_value fun(v: number)
function Dropdown:new(label, items, get_value, set_value)
	Node.new(self)
	self.label = label
	self.items = items
	self.get_value = get_value
	self.set_value = set_value
	self.handles_mouse_input = true
	self.is_open = false
	self.layout_box:setWidth(300)
	self.layout_box:setHeight(LABEL_HEIGHT + LABEL_GAP + BOX_HEIGHT)

	self.label_text = self:add(Label(Resources:newTextBatch("regular", 24, label)))

	self.value_text = self:add(Label(Resources:newTextBatch("regular", 24)))
	self.value_text:setOrigin("center_left")
	self.value_text:setX(ITEM_INSET)
	self.value_text:setY(LABEL_HEIGHT + LABEL_GAP + BOX_HEIGHT / 2)
	self:updateValueLabel()

	self.dropdown_items = self:add(DropdownItems(items, get_value, set_value, self))
end

function Dropdown:updateValueLabel()
	local current = self.get_value()
	if current >= 1 and current <= #self.items then
		self.value_text:setText(self.items[current])
	else
		self.value_text:setText("")
	end
end

---@param _ ui.MouseClickEvent
function Dropdown:onMouseClick(_)
	if self.is_open then
		self:close()
	else
		self:open()
	end
	return true
end

function Dropdown:open()
	if #self.items == 0 then
		return
	end
	self.is_open = true
	self.dropdown_items:enable()
end

function Dropdown:close()
	self.is_open = false
	self.dropdown_items:disable()
end

--- Override isMouseOver to only accept clicks on the box area (not the label)
---@param mouse_x number
---@param mouse_y number
---@param imx number
---@param imy number
function Dropdown:isMouseOver(mouse_x, mouse_y, imx, imy)
	local w = self:getCalculatedWidth()
	local box_y = LABEL_HEIGHT + LABEL_GAP
	return imx >= 0 and imx < w and imy >= box_y and imy < box_y + BOX_HEIGHT
end

function Dropdown:draw()
	local w = self:getCalculatedWidth()
	local box_y = LABEL_HEIGHT + LABEL_GAP

	love.graphics.setColor(self.is_open and Colors.button_hover or Colors.button)
	love.graphics.rectangle("fill", 0, box_y, w, BOX_HEIGHT)

	love.graphics.setColor(Colors.outline)
	love.graphics.setLineWidth(1)
	love.graphics.rectangle("line", 0, box_y, w, BOX_HEIGHT)

	local arrow_x = w - 24
	local arrow_y = box_y + BOX_HEIGHT / 2
	local arrow_size = 6

	love.graphics.setColor(Colors.text)
	love.graphics.setLineWidth(2)

	if self.is_open then
		love.graphics.line(arrow_x - arrow_size, arrow_y + 2, arrow_x, arrow_y - 4)
		love.graphics.line(arrow_x, arrow_y - 4, arrow_x + arrow_size, arrow_y + 2)
	else
		love.graphics.line(arrow_x - arrow_size, arrow_y - 4, arrow_x, arrow_y + 2)
		love.graphics.line(arrow_x, arrow_y + 2, arrow_x + arrow_size, arrow_y - 4)
	end
end

return Dropdown
