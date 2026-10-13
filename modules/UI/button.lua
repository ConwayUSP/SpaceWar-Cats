Button = {}
Button.__index = Button
Button.type = "Button"

function Button.new(x, y, width, height, onClick, image, inverted, onPress, onRelease)
  local button = setmetatable({}, Button)
  button.x = x
  button.y = y
  button.width = width
  button.height = height
  button.onClick = onClick
  button.onPress = onPress
  button.onRelease = onRelease
  button.isPressed = false
  button.activeInputId = nil

  button.state = STATIC
  button.isHovered = false
  button.inverted = inverted or false

  if image then
    local setting = newAnimSetting(1, { width = width, height = height }, 0.2, true, 1)
    local path = pngPathFormat({ "assets", "sprites", "UI", image, STATIC })

    addAnimation(button, path, STATIC, setting)
    path = pngPathFormat({ "assets", "sprites", "UI", image, HOVER })
    addAnimation(button, path, HOVER, setting)
  end

  return button
 end
 
function Button:draw()
  if not self.animations then
    return
  end

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

  if self.isPressed and self.onPress then
    self.onPress()
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
  if button == 1 and self.activeInputId == nil and isMouseOver(self, x, y, true) then
    self.activeInputId = "mouse"
    self.isPressed = true

    if not self.onPress and self.onClick then
      self.onClick()
    end
  end
end

function Button:mousereleased(x, y, button)
  if button ~= 1 or self.activeInputId ~= "mouse" then
    return
  end

  self:releaseInput()
end

function Button:touchpressed(id, x, y)
  if self.activeInputId ~= nil or not isMouseOver(self, x, y, true) then
    return false
  end

  self.activeInputId = id
  self.isPressed = true

  if not self.onPress and self.onClick then
    self.onClick()
  end

  return true
end

function Button:touchmoved(id)
  return self.activeInputId == id
end

function Button:touchreleased(id)
  if self.activeInputId ~= id then
    return false
  end

  self:releaseInput()
  return true
end

function Button:releaseInput()
  self.activeInputId = nil
  self.isPressed = false

  if self.onRelease then
    self.onRelease()
  end
end

function Button:cancelTouch()
  if self.activeInputId ~= nil then
    self:releaseInput()
  end
end
