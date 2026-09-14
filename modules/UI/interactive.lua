----------------------------------------
-- Importações de Módulos
----------------------------------------

require("modules.UI.button")

----------------------------------------
-- Classe Interactive
----------------------------------------

Interactive = {}
Interactive.__index = Interactive
Interactive.type = "Interactive"

function Interactive.new(x, y, width, height, onClick, image, frontDrawFunc, onPress, onRelease, getCooldownPercent)
  local self = setmetatable({}, Interactive)
  self.button = Button.new(x, y, width, height, onClick, image, false, onPress, onRelease)
  self.frontDrawFunc = frontDrawFunc
  self.getCooldownPercent = getCooldownPercent or function()
    return 1
  end

  return self
end

function Interactive:draw()
  love.graphics.setShader(grayscaleProgress)
  grayscaleProgress:send("percent", self.cooldownPercent)

  self.button:draw()

  if self.frontDrawFunc then
    self:frontDrawFunc()
  end

  love.graphics.setShader()
end

function Interactive:update(dt)
  self.cooldownPercent = self.getCooldownPercent()

  self.button:update(dt)

  if self.cooldownPercent < 1 then
    self.button.isHovered = false
    self.button.state = STATIC
  end
end

function Interactive:mousepressed(x, y, button)
  self.button:mousepressed(x, y, button)
end

function Interactive:mousereleased(x, y, button)
  self.button:mousereleased(x, y, button)
end