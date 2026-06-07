----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.text")
require("modules.utils.utils")
require("modules.engine.physics")
require("modules.entities.enemy")
require("modules.constructor.upgrades")
require("modules.utils.ui")
require("modules.utils.cursors")

----------------------------------------
-- Classe UpgradeSlot
----------------------------------------

local rarityColors = {
	[COMMON] = {0.7, 0.7, 0.7, 1},
	[RARE] = {0.2, 0.5, 1.0, 1},
	[EPIC] = {0.7, 0.2, 1.0, 1},
	[LEGENDARY] = {1.0, 0.8, 0.1, 1}
}

local UpgradesSlot = {}
UpgradesSlot.__index = UpgradesSlot

function UpgradesSlot.new(upgrade, x, y, width, height)
	local self = setmetatable({}, UpgradesSlot)

	self.upgrade = upgrade

	self.x = x
	self.y = y
	self.width = width
	self.height = height

	self.pos = vec(x, y)
	self.targetPos = vec(x, y)

	self.padding = 12
	self.isHover = false

	self.title = Text.new(
		upgrade.name,
		13,
		{1, 1, 1, 1},
		{x + self.width/2, y + self.padding},
		0,
		true
	)

	self.description = Text.new(
		upgrade.description,
		10,
		{0.85, 0.85, 0.85, 1},
		{x + self.padding, y + 50},
		0,
		false,
		math.huge,
		nil,
		width - self.padding * 2,
		"center"
	)

	return self
end

function UpgradesSlot:update(dt)
	self.title:update(dt)
	self.description:update(dt)

	self.pos.y = lerp(self.pos.y, self.targetPos.y, 10 * dt)
	self.title.pos[2] = self.pos.y + self.padding
	self.description.pos[2] = self.pos.y + 50

	if self.isHover then
		self.targetPos = vec(self.x, self.y - 5)
		love.mouse.setCursor(cursors.hand)
	else
		self.targetPos = vec(self.x, self.y)
		love.mouse.setCursor(cursors.arrow)
	end
end

function UpgradesSlot:mouseOver(x, y)
	local gameX, gameY = screenToGamePosition(x, y)
	return gameX >= self.x and gameX <= self.x + self.width and gameY >= self.y and gameY <= self.y + self.height
end

function UpgradesSlot:draw()
	-- Fundo
	love.graphics.setColor(0.15, 0.15, 0.15, 1)
	love.graphics.rectangle(
		"fill",
		self.pos.x,
		self.pos.y,
		self.width,
		self.height,
		5,
		5
	)

	-- Borda
	local color = rarityColors[self.upgrade.rarity] or {1, 1, 1, 1}
	love.graphics.setColor(color[1], color[2], color[3], self.isHover and 1 or 0.6)
	-- love.graphics.setColor(1, 1, 1, 0.2)
	love.graphics.rectangle(
		"line",
		self.pos.x,
		self.pos.y,
		self.width,
		self.height,
		5,
		5
	)

	self.title:draw()
	self.description:draw()

	love.graphics.setColor(1, 1, 1, 1)
end

----------------------------------------
-- Estado do Upgrades
----------------------------------------

local UpgradesState = {}
UpgradesState.__index = UpgradesState

UpgradesState.sprites = {}
UpgradesState.texts = {}

UpgradesState.titleFont = nil
UpgradesState.promptFont = nil
UpgradesState.sounds = {}
UpgradesState.timer = 0
UpgradesState.slots = {}
UpgradesState.slotsCount = 3

UpgradesState.allUpgrades = upgradesList

function UpgradesState:load()
	UIManager:changeScene(nil)

	local upgrades = self:getRandomUpgrades()

	local slotWidth = 120
	local slotHeight = 130
	local gap = 20

	local startX = flexCenter(self.slotsCount, slotWidth, gap)
	local y = (VIRTUAL_HEIGHT - slotHeight) / 2

	for i, upgrade in ipairs(upgrades) do
		local x = startX + (i - 1) * (slotWidth + gap)

		local slot = UpgradesSlot.new(
			upgrade,
			x,
			y,
			slotWidth,
			slotHeight
		)

		table.insert(self.slots, slot)
	end
end

function UpgradesState:getRandomUpgrades()
	local shuffled = {}
	for _, upgrade in ipairs(self.allUpgrades) do
		table.insert(shuffled, upgrade)
	end

	for i = #shuffled, 2, -1 do
		local j = math.random(1, i)
		shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
	end

	return {shuffled[1], shuffled[2], shuffled[3]}
end

function UpgradesState:handleSlotClick(slot, x, y)
	local isClicked = slot:mouseOver(x, y)

	if isClicked then
		self:applyUpgrade(slot.upgrade)
		SetGameCtx(CTX.BATTLE)
	end
end

function UpgradesState:applyUpgrade(upgrade)
	upgrade.apply()
end

function UpgradesState:update(dt)
  -- Physics:update(dt)
	planet:update(dt)

	local isHover = false
	for _, slot in ipairs(self.slots) do
		slot:update(dt)
		local mouseX, mouseY = love.mouse.getPosition()
		if slot:mouseOver(mouseX, mouseY) then
			slot.isHover = true
			isHover = true
		else
			slot.isHover = false
		end
	end

	if isHover then
		love.mouse.setCursor(cursors.hand)
	else
		love.mouse.setCursor(cursors.arrow)
	end

	updateTexts(self.texts, dt)
	cleanUpTexts(self.texts)
end

function UpgradesState:draw()
	love.graphics.setColor(1, 1, 1, 1)
	planet:draw()
  p1:draw()

	love.graphics.setColor(0.16, 0.1, 0.24, 0.4)
	love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
	love.graphics.setColor(1, 1, 1, 1)

	for _, slot in ipairs(self.slots) do
		slot:draw()
	end
end

function UpgradesState:keypressed(key, scancode, isrepeat)
	p1:keypressed(key, scancode, isrepeat)
end

function UpgradesState:mousepressed( x, y, button, istouch, presses )
	for _, slot in ipairs(self.slots) do
		self:handleSlotClick(slot, x, y)
	end
end

return UpgradesState