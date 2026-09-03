Button = {}
Button.__index = Button
Button.type = "Button"

function Button.new(x, y, width, height, onClick, image, inverted)
  local button = setmetatable({}, Button)
  button.x = x
  button.y = y
  button.width = width
  button.height = height
  button.onClick = onClick

  button.state = STATIC
  button.isHovered = false
  button.inverted = inverted or false

  local setting = newAnimSetting(1, { width = width, height = height }, 0.2, true, 1)
  local path = pngPathFormat({ "assets", "sprites", "UI", image, STATIC })

  addAnimation(button, path, STATIC, setting)
  path = pngPathFormat({ "assets", "sprites", "UI", image, HOVER })
  addAnimation(button, path, HOVER, setting)

  return button
 end
 
function Button:draw()
  local animation = self.animations[self.state]
  local quad = animation.frames[animation.currFrame]
  local offset = {
    x = animation.frameDim.width / 2,
    y = animation.frameDim.height / 2,
  }
  local scaleX = self.inverted and -1 or 1
  love.graphics.draw(self.spriteSheets[self.state], quad, self.x, self.y, 0, scaleX, 1, offset.x, offset.y)
end
 
function Button:update(dt)
  if self.animation then
    self.animations[self.state]:update(dt)
  end

  local mouseX, mouseY = love.mouse.getPosition()
  self.isHovered = isMouseOver(self, mouseX, mouseY, true)
  self.state = self.isHovered and HOVER or STATIC

end

function Button:isMouseOver()
	local mouseX, mouseY = love.mouse.getPosition()

	return isMouseOver(self, mouseX, mouseY, true)
end

function Button:mousepressed(x, y, button)
  if button == 1 and isMouseOver(self, x, y, true) then
    if self.onClick then
      self.onClick()
    end
  end
end