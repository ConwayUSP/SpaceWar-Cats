----------------------------------------
-- Importacoes de modulos
----------------------------------------
require("modules.UI.button")
require("modules.engine.text")
require("modules.engine.animation")
require("modules.constructor.spaceship")
require("modules.utils.cursors")

----------------------------------------
-- Interface de selecao de nave
----------------------------------------

ShipSelectionUI = {}
ShipSelectionUI.__index = ShipSelectionUI
ShipSelectionUI.type = "ShipSelectionUI"

function ShipSelectionUI.new(onConfirm)
  local self = setmetatable({}, ShipSelectionUI)

  self.selectedIndex = 1
  self.onConfirm = onConfirm

  self.panel = { x = 70, y = 68, width = 500, height = 260 }
  self.shipCard = { x = 105, y = 88, width = 185, height = 185 }
  self.infoCard = { x = 330, y = 88, width = 205, height = 185 }
  self.selectButtonBounds = { x = VIRTUAL_WIDTH / 2, y = 300, width = 165, height = 30 }

  self.nameText = Text.new("", 24, {1, 1, 1, 1}, vec(198, 112), 0, true)
  self.descriptionText = Text.new("", 14, {1, 1, 1, 0.9}, vec(345, 108), 0, false, nil, nil, 175, "left")
  self.superNameText = Text.new("", 14, {1, 1, 1, 1}, vec(345, 185), 0, false, nil, nil, 175, "left")
  self.superDescriptionText = Text.new("", 12, {1, 1, 1, 0.8}, vec(395, 215), 0, false, nil, nil, 125, "left")
  self.selectText = Text.new("SELECT", 18, {1, 1, 1, 1}, vec(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT - 50), 0, true)

  self.leftButton = Button.new(88, 180, 32, 32, function()
    self:previous()
  end, "arrow", true)

  self.rightButton = Button.new(307, 180, 32, 32, function()
    self:next()
  end, "arrow")

  self.selectButton = Button.new(
    self.selectButtonBounds.x,
    self.selectButtonBounds.y,
    self.selectButtonBounds.width,
    self.selectButtonBounds.height,
    function()
      self:confirm()
    end
  )

  self:setSelectedIndex(self.selectedIndex)

  return self
end

function ShipSelectionUI:setSelectedIndex(index)
  self.selectedIndex = (index - 1) % #SpaceshipPool + 1
  self.selected = SpaceshipPool[self.selectedIndex]

  self.nameText.content = self.selected.name
  self.descriptionText.content = self.selected.description
  self.superNameText.content = "SPECIAL: " .. self.selected.superName
  self.superDescriptionText.content = self.selected.superDescription

  local shipPath = pngPathFormat({ "assets", "animations", "player", self.selected.name,  FLYING })

  self.shipImage = love.graphics.newImage(shipPath)
  self.shipAnimation = newAnimation(shipPath, newAnimSetting(4, {width = 32, height = 32}, 0.1, true, 1))

  local superPath = pngPathFormat({ "assets", "sprites", "super", self.selected.superName })
  self.superImage = love.graphics.newImage(superPath)
end

function ShipSelectionUI:previous()
  self:setSelectedIndex(self.selectedIndex - 1)
  soundManager:play("select1")
end

function ShipSelectionUI:next()
  self:setSelectedIndex(self.selectedIndex + 1)
  soundManager:play("select1")
end

function ShipSelectionUI:confirm()
  soundManager:play("select2")
  self.onConfirm(self.selected)
end

function ShipSelectionUI:update(dt)
  self.shipAnimation:update(dt)
  self.leftButton:update(dt)
  self.rightButton:update(dt)
  self.selectButton:update(dt)

  self.nameText:update(dt)
  self.descriptionText:update(dt)
  self.superNameText:update(dt)
  self.superDescriptionText:update(dt)
  self.selectText:update(dt)

  local hovering = self.leftButton.isHovered
    or self.rightButton.isHovered
    or self.selectButton.isHovered
  love.mouse.setCursor(hovering and cursors.hand or cursors.arrow)

  self.selectText.color[4] = self.selectButton.isHovered and 1 or 0.75
end

function ShipSelectionUI:drawPanel()
  -- love.graphics.setColor(0.04, 0.03, 0.11, 0.92)
  -- love.graphics.rectangle("fill", self.panel.x, self.panel.y, self.panel.width, self.panel.height)
  -- love.graphics.setColor(1, 1, 1, 1)
  -- love.graphics.rectangle("line", self.panel.x, self.panel.y, self.panel.width, self.panel.height)

  love.graphics.setColor(0.04, 0.03, 0.11, 0.88)
  love.graphics.rectangle("fill", self.shipCard.x, self.shipCard.y, self.shipCard.width, self.shipCard.height)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.rectangle("line", self.shipCard.x, self.shipCard.y, self.shipCard.width, self.shipCard.height)

  love.graphics.setColor(0.04, 0.03, 0.11, 0.88)
  love.graphics.rectangle("fill", self.infoCard.x, self.infoCard.y, self.infoCard.width, self.infoCard.height)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.rectangle("line", self.infoCard.x, self.infoCard.y, self.infoCard.width, self.infoCard.height)

  -- love.graphics.rectangle(
  --   "line",
  --   self.selectButtonBounds.x - self.selectButtonBounds.width / 2,
  --   self.selectButtonBounds.y - self.selectButtonBounds.height / 2,
  --   self.selectButtonBounds.width,
  --   self.selectButtonBounds.height
  -- )
end

function ShipSelectionUI:drawShip()
  local animation = self.shipAnimation
  local quad = animation.frames[animation.currFrame]
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(self.shipImage, quad, 198, 190, 0, 3, 3, 16, 16)
end

function ShipSelectionUI:draw()
  self:drawPanel()
  self:drawShip()

  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(self.superImage, 365, 230, 0, 1.25, 1.25, 16, 16)

  self.leftButton:draw()
  self.rightButton:draw()
  self.selectButton:draw()

  self.nameText:draw()
  self.descriptionText:draw()
  self.superNameText:draw()
  self.superDescriptionText:draw()
  self.selectText:draw()

  love.graphics.setColor(1, 1, 1, 1)
end

function ShipSelectionUI:mousepressed(x, y, button, istouch, presses)
  self.leftButton:mousepressed(x, y, button)
  self.rightButton:mousepressed(x, y, button)
  self.selectButton:mousepressed(x, y, button)
end

function ShipSelectionUI:mousereleased(x, y, button, istouch, presses)
  self.leftButton:mousereleased(x, y, button)
  self.rightButton:mousereleased(x, y, button)
  self.selectButton:mousereleased(x, y, button)
end
