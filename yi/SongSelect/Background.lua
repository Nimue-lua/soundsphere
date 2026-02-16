local Node = require("ui.view.Node")

---@class yi.SongSelect.Background : view.Node
---@overload fun(background_model: sphere.BackgroundModel): yi.SongSelect.Background
local Background = Node + {}

---@param background_model sphere.BackgroundModel
function Background:new(background_model)
	Node.new(self)
	self.background_model = background_model
	self:setWidth("100%")
	self:setHeight("100%")
end

function Background:draw()
	local images = self.background_model.images
	local alpha = self.background_model.alpha
	local dim = 0.5
	local w, h = self:getCalculatedWidth(), self:getCalculatedHeight()

	for i = 1, 3 do
		if not images[i] then
			return
		end

		if i == 1 then
			love.graphics.setColor(dim, dim, dim, 1)
		elseif i == 2 then
			love.graphics.setColor(dim, dim, dim, alpha)
		elseif i == 3 then
			love.graphics.setColor(dim, dim, dim, 0)
		end

		local img = images[i]
		local iw, ih = img:getDimensions()
		local s = math.max(h / ih, w / iw)
		love.graphics.draw(img, w / 2, h / 2, 0, s, s, iw / 2, ih / 2)
	end
end

return Background
