local Screen = require("yi.Screen")
local Node = require("ui.view.Node")
local Label = require("ui.view.Label")
local Rectangle = require("ui.view.Rectangle")
local Fonts = require("yi.Fonts")
local Colors = require("yi.Colors")
local Images = require("yi.Images")
local L = require("yi.L")
local Tag = require("yi.SongSelect.Tag")
local Cell = require("yi.SongSelect.Cell")
local ChartSetList = require("yi.SongSelect.ChartSetList")
local ChartGrid = require("yi.SongSelect.ChartGrid")
local Button = require("yi.SongSelect.Button")
local Text = require("ui.view.Text")

local ImGuiSettings = require("ui.views.SettingsView")
local ImGuiModifiers = require("ui.views.ModifierView")
local ImGuiInputs = require("ui.views.InputView")
local ImGuiSkins = require("ui.views.NoteSkinView")
local ImGuiGameplayConfig = require("ui.views.SelectView.PlayConfigView")

local layout = require("yi.layout")

---@class yi.SongSelect : yi.Screen
---@overload fun(ui: yi.UserInterface)
local SongSelect = Screen + {}

local info = {
	width = "70%",
	padding = {20, 20, 20, 20},
	justify_content = "space_between",
	arrange = "flow_v",
	align_items = "stretch",
}

local function TopInfo()
	return {Node(), arrange = "flow_v", stencil = true, child_gap = 15,
		{Node(), arrange = "flow_h", child_gap = 10,
			{Tag(), id = "ranked_status"},
			{Tag(), id = "format"},
		},
		{Node(), arrange = "flow_v",
			{Label(Fonts.Black, 80, L.loading), color = Colors.text, id = "title"},
			{Label(Fonts.Bold, 55, L.loading), y = -5, color = Colors.lines, id = "artist"},
		}
	}
end

local function ChartInfo()
	return {Node(), arrange = "flow_v", child_gap = 10, stencil = true, width = "100%",
		{Node(), arrange = "flow_h", child_gap = 10, width = "100%",
			{Cell(L.difficulty), id = "difficulty"},
			{Cell(L.mode), id = "mode"},
			{Cell(L.bpm), id = "bpm"},
			{Cell(L.duration), id = "duration"},
			{Cell(L.notes), id = "notes"},
		},
		{Node(), id = "bottom_tags", arrange = "flow_h", child_gap = 10},
	}
end

---@param ui yi.UserInterface
function SongSelect:new(ui)
	Screen.new(self)
	self.ui = ui
	self.select_model = ui.game.selectModel
	self.select_controller = ui.game.selectController

	self.handles_keyboard_input = true
	self:setWidth("100%")
	self:setHeight("100%")
	self:setArrange("flow_h")
	self:setAlignItems("stretch")

	local function open_config()
		self.ui:setImguiModal(ImGuiSettings)
	end

	local function open_mods()
		self.ui:setImguiModal(ImGuiModifiers)
	end

	local function open_inputs()
		self.ui:setImguiModal(ImGuiInputs)
	end

	local function open_skins()
		self.ui:setImguiModal(ImGuiSkins)
	end

	local function open_gameplay()
		self.ui:setImguiModal(ImGuiGameplayConfig)
	end

	local function play()
		self.ui:changeScreen(self.ui.ScreenName.Gameplay)
	end

	self.ids = layout(self, {
		{Node(), info,
			{Node(), arrange = "flow_v", child_gap = 20,
				TopInfo(),
				{ChartGrid(self.select_model), id = "chart_grid", width = "100%", height = 70, stencil = true},
				ChartInfo(),
			},
			{Label(Fonts.Bold, 20, "This game uses MiSans fonts, provided by Xiaomi Inc. under the MiSans Font Intellectual Property License Agreement."), color = {1 ,1 ,1, 1}},
			{Node(), arrange = "flow_h", child_gap = 10,
				{Button(open_config, Text(Fonts.Bold, 40, L.config)), height = 50},
				{Button(open_mods, Text(Fonts.Bold, 40, L.mods)), height = 50},
				{Button(open_inputs, Text(Fonts.Bold, 40, L.inputs)), height = 50},
				{Button(open_skins, Text(Fonts.Bold, 40, L.skins)), height = 50},
				{Button(open_gameplay, Text(Fonts.Bold, 40, L.gameplay)), height = 50},
				{Button(play, Text(Fonts.Bold, 40, L.play), true), height = 50}
			}
		},
		{Node(), id = "third", width = "30%", stencil = true,
			{ChartSetList(self.select_model), width = "100%", height = "100%"}
		},
	})
end

function SongSelect:enter()
	self.select_controller:load()
	love.mouse.setVisible(true)
end

function SongSelect:exit()
	self.select_controller:unload()
	self:kill()
end

---@param dt number
function SongSelect:update(dt)
	local chartview_i = self.select_model.chartview_index
	local chartview_set_i = self.select_model.chartview_set_index

	local chart_changed = chartview_i ~= self.prev_chart_view_index
	local chart_set_changed = chartview_set_i ~= self.prev_chart_view_set_index

	if chart_changed or chart_set_changed then
		self.prev_chart_view_index = chartview_i
		self.prev_chart_view_set_index = chartview_set_i

		local cv = self.select_model.chartview

		if cv then
			self:setChartview(self.select_model.chartview, chart_changed, chart_set_changed)
		end
	end

	self.select_controller:update()
end

function SongSelect:draw()
	local h = self:getCalculatedHeight()
	local ih = Images.Gradient:getHeight()

	love.graphics.setColor(0, 0, 0, 0.7)
	love.graphics.draw(Images.Gradient, 0, 0, 0, 15, h / ih)
end

---@param t {[string]: number}
---@return [string, number]
local function get_top_two(t)
	local first = {nil, -math.huge}
	local second = {nil, -math.huge}

	for key, value in pairs(t) do
		if key ~= "overall" then
			if value > first[2] then
				second = {first[1], first[2]}
				first = {key, value}
			elseif value > second[2] then
				second = {key, value}
			end
		end
	end

	return {first, second}
end

---@param chartview yi.Chartview
---@param chart_changed boolean
---@param chart_set_changed boolean
function SongSelect:setChartview(chartview, chart_changed, chart_set_changed)
	self.ids.title:setText(chartview.title or "Nil Title")
	self.ids.artist:setText(chartview.artist or "Nil Artist")

	local is_ranked = chartview.difftable_chartmetas and #chartview.difftable_chartmetas > 0

	if is_ranked then
		self.ids.ranked_status:setText(L.ranked)
		self.ids.ranked_status:setBackgroundColor(Colors.accent)
		self.ids.ranked_status:setTextColor({0, 0, 0, 1})
	else
		self.ids.ranked_status:setText(L.unranked)
		self.ids.ranked_status:setBackgroundColor(Colors.lines)
		self.ids.ranked_status:setTextColor(Colors.text)
	end

	self.ids.format:setText((chartview.format or "unknown"):upper())

	local minutes = chartview.duration / 60
	local seconds = chartview.duration % 60
	self.ids.difficulty:setValueText(("%0.02f*"):format(chartview.osu_diff))
	self.ids.bpm:setValueText(("%i"):format(chartview.tempo))
	self.ids.duration:setValueText(("%i:%02i"):format(minutes, seconds))
	self.ids.notes:setValueText(tostring(chartview.notes_count))

	local input_mode = chartview.inputmode:gsub("key", "K"):gsub("scratch", "S")
	self.ids.mode:setValueText(input_mode)

	local patterns = get_top_two(chartview.msd_diff_data)

	self.ids.bottom_tags.children = {}
	local first = self.ids.bottom_tags:add(Tag())
	first:setText(patterns[1][1]:upper())

	local second = self.ids.bottom_tags:add(Tag())
	second:setText(patterns[2][1]:upper())

	local name = self.ids.bottom_tags:add(Tag())
	name:setText(chartview.name)

	if chart_set_changed then
		self.ids.chart_grid:reloadItems()
	end
end

---@param e ui.KeyDownEvent
function SongSelect:onKeyDown(e)
	if e.key == "return" then
		self.ui:changeScreen(self.ui.ScreenName.Gameplay)
	elseif e.key == "j" then
		self.select_model:scrollNoteChartSet(1)
	elseif e.key == "k" then
		self.select_model:scrollNoteChartSet(-1)
	elseif e.key == "h" then
		self.select_model:scrollNoteChart(-1)
	elseif e.key == "l" then
		self.select_model:scrollNoteChart(1)
	elseif e.key == "f1" then
		self.ui.game.persistence.configModel.configs.settings.graphics.userInterface = "Default"
		self.ui.game.uiModel:switchTheme()
	elseif e.key == "[" then
		self.ui.game.timeRateModel:increase(-1)
		self.ui.game.modifierSelectModel:change()
	elseif e.key == "]" then
		self.ui.game.timeRateModel:increase(1)
		self.ui.game.modifierSelectModel:change()
	elseif e.key == "r" then
		self:setReversed(not self.layout_box.reversed)
	end
end

---@param event table
function SongSelect:receive(event)
	self.select_controller:receive(event)
end

return SongSelect

