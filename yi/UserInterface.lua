local IUserInterface = require("sphere.IUserInterface")
local LayoutEngine = require("ui.layout.LayoutEngine")
local LayoutEnums = require("ui.layout.Enums")
local Enviroment = require("yi.Environment")
local CommandBuffer = require("yi.renderer.CommandBuffer")
local Renderer = require("yi.renderer")
local View = require("yi.views.View")
local ViewState = View.State
local Inputs = require("ui.input.Inputs")
local table_util = require("table_util")

local Resources = require("yi.Resources")
local Localization = require("yi.Localization")

local Background = require("yi.views.Background")

---@class yi.UserInterface : sphere.IUserInterface
---@operator call: yi.UserInterface
---@field screen yi.Screen
local UserInterface = IUserInterface + {}

---@class yi.Chartview
---@field artist string
---@field title string
---@field name string
---@field inputmode string

---@param game sphere.GameController
function UserInterface:new(game)
	self.game = game

	self.layout_update_requesters = {}
	self.layout_engine = LayoutEngine()
	self.inputs = Inputs()
	self.environment = Enviroment(self.game, self.inputs)
	self.rebuild_command_buffer = false
	self.removal_deferred = {}
	self.detach_deferred = {}
	self.dt = 0
end

function UserInterface:load()
	self.game.selectController:load()
	Resources:init(1)
	Localization:apply(require("yi.locales.en"))

	self.root = View()
	self.root.id = "root"

	local top = self.root:add(View()) -- Cursor, Tooltip, Notifications, Dropdown items
	local modals = self.root:add(View())
	local screens = self.root:add(View())
	local background = self.root:add(Background())
	self.environment:setLayers(top, modals, screens, background)

	self.root:mount(self.environment)
	self:updateRootSize()
end

function UserInterface:updateRootSize()
	self.root:setWidth(love.graphics.getWidth())
	self.root:setHeight(love.graphics.getHeight())
end

---@param view yi.View
function UserInterface:updateView(view)
	local state = view.state

	if state == ViewState.Active then
		-- do nothing
	elseif state == ViewState.Loaded then
		self.rebuild_command_buffer = true
		view.state = ViewState.Ready
		view.layout_box:markDirty(LayoutEnums.Axis.Both)
		view:loadComplete()
	elseif state == ViewState.Detached then
		--table.insert(self.detach_deferred, view)
		return
	elseif state == ViewState.Killed then
		--table.insert(self.removal_deferred, view)
		return
	elseif state == ViewState.AwaitsMount then
		error("Encountered a non-mounted node. Make sure you mounted the root and you use View:add() to add nodes to the tree. Do not insert nodes directly into view.children")
	end

	self.inputs:processNode(view)
	view:update(self.dt)

	if not view.layout_box:isValid() then
		table.insert(self.layout_update_requesters, view)
	end

	local c = view.children
	for i = 1, #c do
		self:updateView(c[i])
	end
end

---@param dt number
function UserInterface:update(dt)
	self.game.selectController:update()
	self.inputs:beginFrame(love.mouse.getPosition())
	self.dt = dt
	table_util.clear(self.layout_update_requesters)

	self:updateView(self.root)

	--[[
	for _, v in ipairs(self.detach_deferred) do
	end
	]]
	-- detach nodes
	-- kill nodes

	local updated_roots = self.layout_engine:updateLayout(self.layout_update_requesters)

	if updated_roots then
		for n, _ in pairs(updated_roots) do
			---@cast n yi.View
			n:updateTransforms()
		end
	end

	if self.rebuild_command_buffer then
		self.rebuild_command_buffer = false
		self.command_buffer = CommandBuffer(self.root)
	end
end

---@param view yi.View
function UserInterface:drawView(view)
	Renderer(self.command_buffer)
	local c = view.children
	for i = 1, #c do
		self:drawView(c[i])
	end
end

function UserInterface:draw()
	self:drawView(self.root)
end

---@param event table
function UserInterface:receive(event)
	if event.name == "resize" then
		self:updateRootSize()
		-- Actually requires reloading of the UI
	end
end

return UserInterface
