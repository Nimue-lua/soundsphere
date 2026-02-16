local Node = require("ui.view.Node")
local Label = require("ui.view.Label")
local Colors = require("yi.Colors")
local layout = require("yi.layout")

---@class yi.TabButton : view.Node
---@overload fun(icon_text_batch: ui.TextBatchRef, label_text_batch: ui.TextBatchRef, panel: yi.Panel, index: number): yi.TabButton
---@field selected boolean
local TabButton = Node + {}

---@param icon_text_batch ui.TextBatchRef
---@param label_text_batch ui.TextBatchRef
---@param panel yi.Panel
---@param index number
function TabButton:new(icon_text_batch, label_text_batch, panel, index)
	Node.new(self)
	self.panel = panel
	self.index = index
	self.selected = false
	self.handles_mouse_input = true

	self:setArrange("flow_h")
	self:setPaddings({8, 12, 8, 12})
	self:setChildGap(8)

	self:add(Label(icon_text_batch))
	self:add(Label(label_text_batch))
end

---@param e ui.MouseDownEvent
function TabButton:onMouseDown(e)
	self.panel:selectTab(self.index)
	return true
end

function TabButton:draw()
	if self.selected then
		love.graphics.setColor(Colors.accent)
	elseif self.mouse_over then
		love.graphics.setColor(Colors.button_hover)
	else
		love.graphics.setColor(Colors.button)
	end
	love.graphics.rectangle("fill", 0, 0, self:getCalculatedWidth(), self:getCalculatedHeight())
end

-------------------------------------------------------------------------------

---@class yi.Panel.TabData
---@field button yi.TabButton
---@field container view.Node

---@class yi.Panel : view.Node
---@overload fun(tabs: yi.Panel.TabData[]): yi.Panel
---@field tabs yi.Panel.TabData[]
---@field tabs_container view.Node
---@field content_container view.Node
---@field selected_index number
local Panel = Node + {}

---@param tabs yi.Panel.TabData[]
function Panel:new(tabs)
	Node.new(self)
	self.tabs = {}
	self.selected_index = 0

	self:setArrange("flow_h")
	self:setAlignItems("stretch")
	self:setPaddings({10, 10, 10, 10})
	self:setChildGap(10)

	self.tabs_container = self:add(Node(), {
		arrange = "flow_v",
		child_gap = 8,
		align_items = "stretch"
	})

	self.content_container = self:add(Node(), {
		arrange = "flow_v",
		width = "100%",
		height = "100%",
	})

	-- Process tabs from constructor argument
	for _, tab_data in ipairs(tabs) do
		self:addTab(tab_data)
	end
end

---@param tab_data {icon: ui.TextBatchRef, label: ui.TextBatchRef, content: yi.Thing[]}
function Panel:addTab(tab_data)
	local index = #self.tabs + 1

	local button = TabButton(tab_data.icon, tab_data.label, self, index)
	self.tabs_container:add(button)

	local container = self.content_container:add(Node())
	layout(container, tab_data.content)
	container:disable()
	local tab = {button = button, container = container}
	table.insert(self.tabs, tab)

	if #self.tabs == 1 then
		tab.container:enable()
		tab.button.selected = true
	end
end

---@param index number
function Panel:selectTab(index)
	if index < 1 or index > #self.tabs then
		return
	end

	for _, tab_data in ipairs(self.tabs) do
		tab_data.container:disable()
		tab_data.button.selected = false
	end

	-- Enable selected tab's content
	local tab_data = self.tabs[index]
	tab_data.container:enable()
	tab_data.button.selected = true

	self.selected_index = index
end

function Panel:draw()
	love.graphics.setColor(Colors.panels)
	love.graphics.rectangle("fill", 0, 0, self:getCalculatedWidth(), self:getCalculatedHeight())
end

return Panel
