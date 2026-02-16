local Node = require("ui.view.Node")

---@class yi.SongSelect.Background : view.Node
---@overload fun(background_model: sphere.BackgroundModel): yi.SongSelect.Background
local Background = Node + {}

Background.parallax_scale = 1.02
Background.parallax_strength = 10 -- Maximum offset in pixels
Background.parallax_smoothing = 5

---@param background_model sphere.BackgroundModel
function Background:new(background_model)
	Node.new(self)
	self.background_model = background_model
	self:setWidth("100%")
	self:setHeight("100%")

	self.parallax_x = 0
	self.parallax_y = 0
	self.target_parallax_x = 0
	self.target_parallax_y = 0

	self.dim = 0.5
end

---@param dim number
function Background:setDim(dim)
	self.dim = dim
end

---@param dt number
function Background:update(dt)
	dt = math.min(dt, 0.1) -- Prevent explosion when window is unfocused

	local mx, my = love.mouse.getPosition()
	local imx, imy = self.transform:get():inverseTransformPoint(mx, my)
	local w, h = self:getCalculatedWidth(), self:getCalculatedHeight()

	local norm_x = (imx / w) * 2 - 1
	local norm_y = (imy / h) * 2 - 1

	norm_x = math.max(-1, math.min(1, norm_x))
	norm_y = math.max(-1, math.min(1, norm_y))

	self.target_parallax_x = norm_x * self.parallax_strength
	self.target_parallax_y = norm_y * self.parallax_strength

	local smoothing = math.min(self.parallax_smoothing * dt, 1)
	self.parallax_x = self.parallax_x + (self.target_parallax_x - self.parallax_x) * smoothing
	self.parallax_y = self.parallax_y + (self.target_parallax_y - self.parallax_y) * smoothing
end

function Background:draw()
	local images = self.background_model.images
	local alpha = self.background_model.alpha
	local dim = self.dim
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

		local s = math.max(h / ih, w / iw) * self.parallax_scale
		love.graphics.draw(img, w / 2 + self.parallax_x, h / 2 + self.parallax_y, 0, s, s, iw / 2, ih / 2)
	end
end

return Background
