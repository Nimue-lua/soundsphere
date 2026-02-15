local Node = require("ui.view.Node")
local Theme = require("yi.Fonts")
local Colors = require("yi.Colors")
local Images = require("yi.Images")

---@class yi.SongSelect.ChartSetList : view.Node
---@overload fun(select_model: sphere.SelectModel)
local ChartSetList = Node + {}

ChartSetList.Panels = 9

---@param select_model sphere.SelectModel
function ChartSetList:new(select_model)
	Node.new(self)
	self.select_model = select_model
	self.handles_mouse_input = true
	self.scroll = 0
end

---@param e ui.ScrollEvent
function ChartSetList:onScroll(e)
	self.select_model:scrollNoteChartSet(-e.direction_y)
end

function ChartSetList:update(dt)
	local dest = self.select_model.chartview_set_index
	local diff = dest - self.scroll
	diff = diff * math.pow(0.7, dt * 60)
	self.scroll = dest - diff
end

local x_indent = 15

function ChartSetList:draw()
	local items = self.select_model.noteChartSetLibrary.items
	local w = self:getCalculatedWidth()
	local h = self:getCalculatedHeight()

	if #items == 0 then
		return
	end

	local panel_height = h / self.Panels
	local panel_mid = panel_height / 2
	local mid_offset = (self.Panels - 1) / 2

	love.graphics.setFont(Theme.Bold)

	for i = math.floor(self.scroll - mid_offset - 1), math.ceil(self.scroll + mid_offset + 1) do
		if items[i] then
			local y = (i - self.scroll + mid_offset) * panel_height
			love.graphics.setColor((i % 2) == 0 and Colors.panels or Colors.panels_alt)
			love.graphics.rectangle("fill", 0, y, w, panel_height)
			love.graphics.push()
			love.graphics.translate(x_indent, panel_mid + y)
			love.graphics.setColor(Colors.text)
			love.graphics.print(items[i].title or "Nil Title", 0, -30, 0, 0.2, 0.2)
			love.graphics.setColor(Colors.lines)
			love.graphics.print(items[i].artist or "Nil Artist", 0, 5, 0, 0.2, 0.2)
			love.graphics.pop()
		end
	end

	local img = Images.Gradient
	love.graphics.setColor(Colors.accent)
	love.graphics.draw(img, 0, panel_height * 4, 0, 0.2, panel_height / img:getHeight())
end

return ChartSetList
