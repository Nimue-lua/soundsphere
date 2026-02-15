local class = require("class")
local Node = require("ui.view.Node")
local Rectangle = require("ui.view.Rectangle")
local Engine = require("ui.Engine")

local Fonts = require("yi.Fonts")
local Images = require("yi.Images")
local L = require("yi.L")
local SongSelect = require("yi.SongSelect")
local GameplayView = require("yi.GameplayView")
local Background = require("yi.SongSelect.Background")

---@class yi.UserInterface
---@operator call: yi.UserInterface
---@field screen yi.Screen
local UserInterface = class()

---@class yi.Chartview
---@field artist string
---@field title string
---@field name string
---@field inputmode string

---@enum yi.ScreenName
UserInterface.ScreenName = {
	SongSelect = 1,
	Gameplay = 2,
	Result = 3
}

local ScreenName = UserInterface.ScreenName
local imgui_ctx = {}
UserInterface.gameView = {} -- ImGui needs this

---@param game sphere.GameController
function UserInterface:new(game)
	self.game = game

	imgui_ctx.game = game
	L:apply(require("yi.locales.en"))
	L:apply(require("yi.locales.zh"))
	Fonts:init()
	Images:init()
end

function UserInterface:load()
	self.root = Node()
	self.root.id = "root"
	self.engine = Engine()
	self.engine:setRoot(self.root)

	self.root:add(Background(self.game.backgroundModel))
	self:changeScreen(ScreenName.SongSelect)
end

---@param screen_name yi.ScreenName
function UserInterface:changeScreen(screen_name)
	if self.screen then
		self.screen:exit()
	end

	if screen_name == ScreenName.SongSelect then
		self.screen = self.root:add(SongSelect(self))
	elseif screen_name == ScreenName.Gameplay then
		self.screen = self.root:add(GameplayView(self))
	end

	self.screen:enter()
end

---@deprecated
---@param modal function
function UserInterface:setImguiModal(modal)
	if modal == self.modal then
		self.modal = nil
		return
	end
	self.modal = modal
end


function UserInterface:unload()
	self.screen:exit()
end

---@param dt number
function UserInterface:update(dt)
	self.engine:updateTree(dt)
end

function UserInterface:draw()
	self.engine:drawTree()

	if self.modal then
		self.modal(imgui_ctx)
	end
end

---@param event table
function UserInterface:receive(event)
	if event.name == "keypressed" and event[1] == "escape" and self.modal then
		self.modal = nil
		return
	end
	self.engine:receive(event)
	self.screen:receive(event)
end

return UserInterface
