local Images = {}

function Images:init()
	self.Gradient = love.graphics.newImage("yi/assets/gradient.png")
	self.ChartCell = love.graphics.newImage("yi/assets/chart_cell.png")
end

return Images
