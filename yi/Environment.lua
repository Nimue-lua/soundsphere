local class = require("class")

---@class yi.Environment
---@operator call: yi.Environment
local Environment = class()

---@param game sphere.GameController
---@param inputs ui.Inputs
function Environment:new(game, inputs)
	self.game = game
	self.inputs = inputs
end

---@param top yi.View
---@param modals yi.View
---@param screens yi.View
---@param background yi.Background
function Environment:setLayers(top, modals, screens, background)
	self.top = top
	self.modals = modals
	self.screens = screens
	self.background = background
end

return Environment
