local Node = require("ui.view.Node")
local Colors = require("yi.Colors")
local Resources = require("yi.Resources")

---@class yi.SongSelect.ChartSetList : view.Node
---@overload fun(select_model: sphere.SelectModel)
local ChartSetList = Node + {}

---@param select_model sphere.SelectModel
function ChartSetList:new(select_model)
	Node.new(self)
	self.select_model = select_model
	self.handles_mouse_input = true
	self.scroll = 0
end

function ChartSetList:load()
	Node.load(self)
	self.title_font = Resources:getFont("bold", 24)
	self.artist_font = Resources:getFont("regular", 16)
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

	local title_h = self.title_font.object:getHeight()
	local artist_h = self.artist_font.object:getHeight()
	local gap = 2
	local padding = 25
	local panel_height = title_h + artist_h + gap + padding * 2

	local panels_on_screen = h / panel_height
	local mid_offset = (panels_on_screen - 1) / 2

	for i = math.floor(self.scroll - mid_offset - 1), math.ceil(self.scroll + mid_offset + 1) do
		if items[i] then
			local y = (i - self.scroll + mid_offset) * panel_height
			love.graphics.setColor((i % 2) == 0 and Colors.panels or Colors.panels_alt)
			love.graphics.rectangle("fill", 0, y, w, panel_height)

			love.graphics.setColor(Colors.text)
			love.graphics.setFont(self.title_font.object)
			love.graphics.print(items[i].title or "Nil Title", x_indent, y + padding)

			love.graphics.setColor(Colors.lines)
			love.graphics.setFont(self.artist_font.object)
			love.graphics.print(items[i].artist or "Nil Artist", x_indent, y + padding + title_h + gap)
		end
	end

	local img = Resources.images.gradient
	love.graphics.setColor(Colors.accent)
	love.graphics.draw(img, 0, mid_offset * panel_height, 0, 0.2, panel_height / img:getHeight())
end

return ChartSetList
