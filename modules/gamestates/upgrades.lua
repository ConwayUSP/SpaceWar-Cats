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
	
	self.speed = 15
	self.alpha = 1
	self.scale = 1
	self.angle = 0

	self.canvas = love.graphics.newCanvas(width, height)

	self.initialDelay = delay
	self.delay = self.initialDelay

	local referenceX = VIRTUAL_WIDTH / 2
	local k = 1.2
	self.initialPos = vec(k*(x - referenceX) + referenceX, VIRTUAL_HEIGHT + 100)
	self.pos = vec(self.initialPos.x, self.initialPos.y)
	self.targetPos = vec(x, y)

	self.paddingX = 10
	self.paddingY = 16
	self.isHover = false

	local color = rarityColors[self.upgrade.rarity] or {1, 1, 1, 1}
	self.title = Text.new(
		upgrade.name,
		16,
		color,
		vec(self.width/2, self.paddingY),
		0,
		true
	)

	self.description = Text.new(
		upgrade.description,
		14,
		{0.85, 0.85, 0.85, 1},
		vec(self.paddingX, self.paddingY + 34),
		0,
		false,
		math.huge,
		nil,
		width - self.paddingX * 2,
		"center"
	)

	return self
end

function UpgradesSlot:changeUpgrade(upgrade)
	self.speed = 15
	self.alpha = 1
	self.scale = 1
	self.angle = 0
	self.pos = vec(self.initialPos.x, self.initialPos.y)
	self.delay = self.initialDelay
	self.upgrade = upgrade
	self.title.color = rarityColors[self.upgrade.rarity] or {1, 1, 1, 1}
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

	self.pos.y = lerp(self.pos.y, self.targetPos.y, self.speed * dt)
	self.pos.x = lerp(self.pos.x, self.targetPos.x, self.speed * dt)

	if self.isHover then
		self.targetPos = vec(self.x, self.y - 5)
		self.scale = lerp(self.scale, 1.05, 10 * dt)
		self.angle = math.sin(love.timer.getTime() * 5) * 0.02
		love.mouse.setCursor(cursors.hand)
	else
		self.targetPos = vec(self.x, self.y)
		self.scale = lerp(self.scale, 1.00, 10 * dt)
		self.angle = 0
		love.mouse.setCursor(cursors.arrow)
	end
end

function UpgradesSlot:mouseOver(x, y)
	local gameX, gameY = screenToGamePosition(x, y)
	return gameX >= self.x and gameX <= self.x + self.width and gameY >= self.y and gameY <= self.y + self.height
end

function UpgradesSlot:drawCanvas()
	love.graphics.setCanvas(self.canvas)
	love.graphics.clear()

	-- Fundo
	love.graphics.setColor(0.15, 0.15, 0.15, 1)
	love.graphics.rectangle("fill", 0, 0, self.width, self.height)

	-- Borda
	local color = rarityColors[self.upgrade.rarity] or {1, 1, 1, 1}
	love.graphics.setColor(color[1], color[2], color[3], self.isHover and 1 or 0.6)
	love.graphics.rectangle("line", 0, 0, self.width, self.height)

	self.title:draw()
	self.description:draw()

	love.graphics.setCanvas()
end

function UpgradesSlot:draw()
	love.graphics.push("all")
	love.graphics.origin()
	self:drawCanvas()
	love.graphics.pop()

	love.graphics.setColor(1, 1, 1, self.alpha)
	love.graphics.draw(self.canvas, self.pos.x + self.width/2, self.pos.y + self.height/2, self.angle, self.scale, self.scale, self.width/2, self.height/2)	
	love.graphics.setColor(1,1,1,1)
end

----------------------------------------
-- Estado do Upgrades
----------------------------------------

local UpgradesState = {}
UpgradesState.__index = UpgradesState

UpgradesState.timer = 0
UpgradesState.slots = {}
UpgradesState.slotsCount = 3
UpgradesState.slotActive = nil
UpgradesState.keyPressed = nil

UpgradesState.allUpgrades = upgradesList

function UpgradesState:load()
	self.state = BUYING
	self.timer = 0

	local upgrades = self:getRandomUpgrades()
	self:setSlots(upgrades)
	soundManager:play("ambience", false, true)
end

function UpgradesState:update(dt)
	if self.state == BUYING then
		self:updateSlots(dt)		
	else
		self:updateExit(dt)
	end
end


function UpgradesState:updateExit(dt)
	self.timer = self.timer + dt

	for i, slot in ipairs(self.slots) do
		if i == self.slotActive then
			slot.speed = 6
			slot.targetPos = vec(VIRTUAL_WIDTH/2 - slot.width/2, slot.y - 20)
			slot.scale = lerp(slot.scale, 1.4, dt)
			slot.angle = math.sin(love.timer.getTime() * 5) * 0.02
		else
			slot.scale = lerp(slot.scale, 0.8, 10 * dt)
			slot.alpha = lerp(slot.alpha, 0, 10 * dt)
			slot.angle = 0
		end
		slot:update(dt)
	end

	if self.timer >= 1.5 then
		SetGameCtx(CTX.BATTLE)
	end
end

function UpgradesState:updateSlots(dt)
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
		if not self.triggerHover or idx ~= self.slotActive then
			self.triggerHover = true
			self:selectSlot(idx)
		end
		love.mouse.setCursor(cursors.hand)
		self.keyPressed = nil
	else
		love.mouse.setCursor(cursors.arrow)
		self.triggerHover = false
		if not self.keyPressed then
			self.slotActive = self.slotsCount + 1
		end
	end

	for i, slot in ipairs(self.slots) do
		slot.isHover = (i == self.slotActive)
	end
end

function UpgradesState:draw()
	love.graphics.setColor(1, 1, 1, 1)
	planet:draw()
  p1:draw()
	pProjectiles:draw()
	particleManager:draw()

	love.graphics.setColor(0.08, 0.05, 0.14, 0.8)
	love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
	love.graphics.setColor(1, 1, 1, 1)

	for _, slot in ipairs(self.slots) do
		slot:draw()
	end
end

function UpgradesState:setSlots(upgrades)
	if #self.slots == 0 then
		local slotWidth = 130
		local slotHeight = 100
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
				0.15 * (i - 1)
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
		local weight = weights[upgrade.rarity]
		total = total + weight
	end

	local r = math.random(total)
	local acc = 0

	for i, upgrade in ipairs(pool) do
		local weight = weights[upgrade.rarity]
		acc = acc + weight

		if acc >= r then
			return i
		end
	end
end

function UpgradesState:applyUpgrade(upgrade)
	if self.state ~= BUYING then
		return
	end

	upgrade.apply({
		player = p1,
		planet = planet,
	})

	local rand = math.random(1, 2)
	soundManager:play("buy" .. rand)

	self.state = TRANSITION
end

function UpgradesState:selectSlot(idx)
	self.slotActive = idx
	soundManager:play("select1")
end

-----------------------------------------
--- Handlers de Input
-----------------------------------------

function UpgradesState:keypressed(key, scancode, isrepeat)
	-- p1:keypressed(key, scancode, isrepeat)
	if key == "a" or key == "left" then
		self.keyPressed = key
		self:selectSlot((self.slotActive - 2) % self.slotsCount + 1) 
	elseif key == "d" or key == "right" then
		self.keyPressed = key
		self:selectSlot((self.slotActive == self.slotsCount + 1) and 1 or (self.slotActive) % self.slotsCount + 1)
	end

	if key == "space" or key == "return" then
		local slot = self.slots[self.slotActive]
		if slot then
			self:applyUpgrade(slot.upgrade)
		end
	end
end

function UpgradesState:mousepressed( x, y, button, istouch, presses )
	if self.state == TRANSITION then
		SetGameCtx(CTX.BATTLE)
		return
	end
	
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