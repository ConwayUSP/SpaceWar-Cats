Interactive = {}
Interactive.__index = Interactive
Interactive.type = "Interactive"

function Interactive.new(x, y, width, height, onClick, image)
  local self = setmetatable({}, Interactive)
  self.button = Button.new(x, y, width, height, onClick, image)

  return self
end

function Interactive:draw()
  love.graphics.setShader(grayscaleProgress)
  grayscaleProgress:send("percent", self.cooldownPercent)

  self.button:draw()

  local image = p1.spaceship.weapon.image
  love.graphics.draw(image, self.button.x, self.button.y, 0, 2, 2, image:getWidth() / 2, image:getHeight() / 2)

  love.graphics.setShader()
end

function Interactive:update(dt)
  self.cooldownPercent = p1.spaceship:getCooldownPercent()

  if self.cooldownPercent < 1 then
    self.button.isHovered = false
    self.button.state = STATIC
    return
  end

  self.button:update(dt)
end

function Interactive:mousepressed(x, y, button)
  self.button:mousepressed(x, y, button)
end