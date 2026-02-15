---@class yi.Fonts
local Fonts = {}

function Fonts:init()
	self.Black = love.graphics.newFont("yi/MiSans/MiSans-Heavy.ttf", 100)
	self.Bold = love.graphics.newFont("yi/MiSans/MiSans-Bold.ttf", 100)
	self.Regular = love.graphics.newFont("yi/MiSans/MiSans-Regular.ttf", 100)
end

return Fonts
