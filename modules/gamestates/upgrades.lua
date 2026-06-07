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

function UpgradesSlot.new(upgrade, x, y, width, height, delay)
	local self = setmetatable({}, UpgradesSlot)

	self.upgrade = upgrade

	self.x = x
	self.y = y
	self.width = width
	self.height = height

	self.initialDelay = delay
	self.delay = self.initialDelay

	local referenceX = VIRTUAL_WIDTH / 2
	local k = 1.2
	self.initialPos = vec(k*(x - referenceX) + referenceX, VIRTUAL_HEIGHT + 100)
	self.pos = vec(self.initialPos.x, self.initialPos.y)
	self.targetPos = vec(x, y)

	self.padding = 12
	self.isHover = false

	self.title = Text.new(
		upgrade.name,
		13,
		{1, 1, 1, 1},
		{self.pos.x + self.width/2, self.pos.y + self.padding},
		0,
		true
	)

	self.description = Text.new(
		upgrade.description,
		10,
		{0.85, 0.85, 0.85, 1},
		{self.pos.x + self.padding, self.pos.y + 50},
		0,
		false,
		math.huge,
		nil,
		width - self.padding * 2,
		"center"
	)

	return self
end

function UpgradesSlot:attachTexts()
	self.title.pos[1] = self.pos.x + self.width / 2
	self.title.pos[2] = self.pos.y + self.padding
	self.description.pos[1] = self.pos.x + self.padding
	self.description.pos[2] = self.pos.y + 50
end

function UpgradesSlot:changeUpgrade(upgrade)
	self.delay = self.initialDelay
	self.pos = vec(self.initialPos.x, self.initialPos.y)
	self:attachTexts()
	self.upgrade = upgrade
	self.title.content = upgrade.name
	self.description.content = upgrade.description
end

function UpgradesSlot:update(dt)
	if self.delay > 0 then
		self.delay = self.delay - dt
		return
	end
	
	self.title:update(dt)
	self.description:update(dt)

	local speed = 15
	self.pos.y = lerp(self.pos.y, self.targetPos.y, speed * dt)
	self.pos.x = lerp(self.pos.x, self.targetPos.x, speed * dt)
	self:attachTexts()

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
UpgradesState.slotActive = nil
UpgradesState.keyPressed = nil

UpgradesState.allUpgrades = upgradesList

function UpgradesState:load()
	UIManager:changeScene(nil)

	local upgrades = self:getRandomUpgrades()
	self:setSlots(upgrades)
end

function UpgradesState:setSlots(upgrades)
	if #self.slots == 0 then
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
				slotHeight,
				0.1 * (i - 1)
			)

			table.insert(self.slots, slot)
		end
	else
		for i, upgrade in ipairs(upgrades) do
			self.slots[i]:changeUpgrade(upgrade)
		end
	end
end

function UpgradesState:getRandomUpgrades()
	local result = {}
	local pool = {}

	for _, u in ipairs(self.allUpgrades) do
		table.insert(pool, u)
	end

	for _ = 1, self.slotsCount do
		i = self:pickRandomUpgrade(pool)

		table.insert(result, pool[i])
		table.remove(pool, i)
	end

	return result
end

function UpgradesState:pickRandomUpgrade(pool)
	local total = 0

	for _, upgrade in ipairs(pool) do
		total = total + upgrade.weight
	end

	local r = math.random(total)
	local acc = 0

	for i, upgrade in ipairs(pool) do
		acc = acc + upgrade.weight

		if acc >= r then
			return i
		end
	end
end

function UpgradesState:applyUpgrade(upgrade)
	upgrade.apply()
	SetGameCtx(CTX.BATTLE)
end

function UpgradesState:update(dt)
  -- Physics:update(dt)
	planet:update(dt)

	local isHover = false
	local idx = 0
	for i, slot in ipairs(self.slots) do
		slot:update(dt)
		local mouseX, mouseY = love.mouse.getPosition()
		if slot:mouseOver(mouseX, mouseY) then
			isHover = true
			idx = i
		end
	end

	if isHover then
		love.mouse.setCursor(cursors.hand)
		self.slotActive = idx
		self.keyPressed = nil
	else
		love.mouse.setCursor(cursors.arrow)
		if not self.keyPressed then
			self.slotActive = self.slotsCount + 1
		end
	end

	for i, slot in ipairs(self.slots) do
		slot.isHover = (i == self.slotActive)
	end

	updateTexts(self.texts, dt)
	cleanUpTexts(self.texts)
end

function UpgradesState:draw()
	love.graphics.setColor(1, 1, 1, 1)
	planet:draw()
  p1:draw()

	love.graphics.setColor(0.08, 0.05, 0.14, 0.8)
	love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
	love.graphics.setColor(1, 1, 1, 1)

	for _, slot in ipairs(self.slots) do
		slot:draw()
	end
end

function UpgradesState:keypressed(key, scancode, isrepeat)
	-- p1:keypressed(key, scancode, isrepeat)
	if key == "a" or key == "left" then
		self.keyPressed = key
		self.slotActive = (self.slotActive - 2) % self.slotsCount + 1
	elseif key == "d" or key == "right" then
		self.keyPressed = key
		self.slotActive = (self.slotActive == self.slotsCount + 1) and 1 or (self.slotActive) % self.slotsCount + 1
	end

	if key == "space" or key == "return" then
		local slot = self.slots[self.slotActive]
		if slot then
			self:applyUpgrade(slot.upgrade)
		end
	end
end

function UpgradesState:mousepressed( x, y, button, istouch, presses )
	for _, slot in ipairs(self.slots) do
		self:handleSlotClick(slot, x, y)
	end
end

function UpgradesState:handleSlotClick(slot, x, y)
	local isClicked = slot:mouseOver(x, y)

	if isClicked then
		self:applyUpgrade(slot.upgrade)
	end
end

return UpgradesState