----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.system.render")

----------------------------------------
-- Classe Text
----------------------------------------

Text = {}
Text.__index = Text
Text.type = "Text"

function Text.new(content, size, color, pos, rotation, centerOffset, lifetime, updateFunc, maxWidth)
	local text = setmetatable({}, Text)

	text.content = content
	text.size = size
	text.color = color
	text.pos = pos
	text.rotation = rotation or 0
	text.centerOffset = centerOffset
	text.timer = lifetime or math.huge
	text.customUpdate = updateFunc or function() end
	text.isOver = false
	text.maxWidth = maxWidth
	text.font = returnFont(size)

	return text
end

function Text:getDimensions()
	local font = self.font or love.graphics.getFont()
	local content = self.content or ""

	if self.maxWidth then
		local _, lines = font:getWrap(content, self.maxWidth)
		local height = #lines * font:getHeight()
		return self.maxWidth, height
	else
		return font:getWidth(content), font:getHeight()
	end
end

function Text:update(dt, ...)
	self:customUpdate(dt, ...)
	self.timer = self.timer - dt
	if self.timer <= 0 then
		self.isOver = true
	end
end

function Text:draw()
	-- salvar estado atual
	local prevFont = love.graphics.getFont()
	local prevR, prevG, prevB, prevA = love.graphics.getColor()

	local font = self.font or prevFont
	love.graphics.setFont(font)

	local content = self.content or ""
	local width, height = self:getDimensions()

	local x = self.pos[1]
	local y = self.pos[2]
	local rotation = self.rotation or 0
	local scale = self.scale or 1
	local ox, oy = 0, 0

	if self.centerOffset then
		ox = width / 2
		oy = height / 2
	end

	local color = self.color or { 1, 1, 1, 1 }
	love.graphics.setColor(color[1], color[2], color[3], color[4] or 1)
	if self.maxWidth then
		love.graphics.printf(content, x, y, self.maxWidth, self.align or "left", rotation, scale, scale, ox, oy)
	else
		love.graphics.print(content, x, y, rotation, scale, scale, ox, oy)
	end

	-- restaurar estado anterior
	love.graphics.setFont(prevFont)
	love.graphics.setColor(prevR, prevG, prevB, prevA)
end

TextPhysical = setmetatable({}, { __index = Text })
TextPhysical.__index = TextPhysical

function TextPhysical.new(content, size, color, pos, rotation, centerOffset, lifetime, updateFunc, maxWidth, onHit)
	local text = Text.new(content, size, color, pos, rotation, centerOffset, lifetime, updateFunc, maxWidth)
	setmetatable(text, TextPhysical)

	local w, h = text:getDimensions()

	text.body = love.physics.newBody(Physics.world, pos[1], pos[2], "dynamic")
	text.body:setFixedRotation(true)
	text.realSize = { width = w, height = h }
	text.shape = love.physics.newRectangleShape(w, h)
	text.fixture = love.physics.newFixture(text.body, text.shape)
	text.fixture:setUserData(text)
	text.fixture:setFilterData(
		CATEGORY.TEXT, 
		CATEGORY.PLAYER + CATEGORY.PLAYER_BULLET, 
		0
	)
	text.fixture:setSensor(true)
	text.onHit = onHit

	return text
end

function TextPhysical:draw()
	Text.draw(self)
	debugRender(self)

end

---------------------------------
-- Global
--------------------------------

function cleanUpTexts(texts)
	for k, v in pairs(texts) do
		if v.isOver then
			texts[k] = nil
		end
	end
end

function updateTexts(texts, dt)
	for _, text in pairs(texts) do
		text:update(dt)
	end
end

function drawTexts(texts)
	for _, text in pairs(texts) do
		text:draw()
	end
end
