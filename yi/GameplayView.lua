local Screen = require("yi.Screen")
local SequenceView = require("sphere.views.SequenceView")

---@class yi.GameplayView : yi.Screen
---@overload fun(ui: yi.UserInterface): yi.GameplayView
local GameplayView = Screen + {}

---@param ui yi.UserInterface
function GameplayView:new(ui)
	Screen.new(self)
	self:setGrow(1)
	self.ui = ui
	self.seq_view = SequenceView()

	self.handles_keyboard_input = true
end

function GameplayView:enter()
	self.ui.game.gameInteractor:loadGameplaySelectedChart()
	self.seq_view.game = self.ui.game
	self.seq_view.subscreen = "gameplay"
	self.seq_view:setSequenceConfig(self.ui.game.noteSkinModel.noteSkin.playField)
	self.seq_view:load()
	love.mouse.setVisible(false)
end

function GameplayView:exit()
	self.ui.game.gameplayInteractor:retry() -- TEMPORARY
	self.ui.game.gameplayInteractor:unloadGameplay()
	self.seq_view:unload()
	self:kill()
end

---@param dt number
function GameplayView:update(dt)
	self.seq_view:update(dt)
end

function GameplayView:draw()
	self.seq_view:draw()
end

---@param e ui.KeyDownEvent
function GameplayView:onKeyDown(e)
	if e.key == "escape" then
		self.ui:changeScreen(self.ui.ScreenName.SongSelect)
	end
end

---@param event table
function GameplayView:receive(event)
	self.ui.game.gameplayInteractor:receive(event)
	self.seq_view:receive(event)
end

return GameplayView
