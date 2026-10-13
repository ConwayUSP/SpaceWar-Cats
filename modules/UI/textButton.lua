require("modules.UI.button")
require("modules.utils.utils")

TextButton = {}
TextButton.__index = TextButton
TextButton.type = "TextButton"

local function colorOr(value, fallback)
  return value or fallback
end

function TextButton.new(x, y, width, height, text, onClick, style)
  style = style or {}

  local self = setmetatable({}, TextButton)
  self.button = Button.new(x, y, width, height, onClick)
  self.text = text
  self.font = returnFont(style.fontSize or 13)
  self.hasOutline = style.hasOutline ~= false

  self.fillColor = colorOr(style.fillColor, {0.26, 0.26, 0.29, 0.84})
  self.hoverFillColor = colorOr(style.hoverFillColor, {0.38, 0.38, 0.42, 0.94})
  self.pressedFillColor = colorOr(style.pressedFillColor, {0.46, 0.46, 0.5, 1})
  self.outlineColor = colorOr(style.outlineColor, {1, 1, 1, 1})
  self.hoverOutlineColor = colorOr(style.hoverOutlineColor, {1, 1, 1, 1})
  self.textColor = colorOr(style.textColor, {1, 1, 1, 1})

  self.isHovered = false
  self.isPressed = false

  return self
end

function TextButton:update(dt)
  self.button:update(dt)
  self.isHovered = self.button.isHovered
  self.isPressed = self.button.isPressed
end

function TextButton:draw()
  local button = self.button
  local fillColor = self.fillColor

  if self.isPressed then
    fillColor = self.pressedFillColor
  elseif self.isHovered then
    fillColor = self.hoverFillColor
  end

  love.graphics.setColor(fillColor[1], fillColor[2], fillColor[3], fillColor[4])
  love.graphics.rectangle(
    "fill",
    button.x - button.width / 2,
    button.y - button.height / 2,
    button.width,
    button.height
  )

  if self.hasOutline then
    local outlineColor = self.isHovered and self.hoverOutlineColor or self.outlineColor
    love.graphics.setColor(outlineColor[1], outlineColor[2], outlineColor[3], outlineColor[4])
    love.graphics.rectangle(
      "line",
      button.x - button.width / 2,
      button.y - button.height / 2,
      button.width,
      button.height
    )
  end

  local textY = button.y - self.font:getHeight() / 2 + (self.isPressed and 1 or 0)
  love.graphics.setFont(self.font)
  love.graphics.setColor(self.textColor[1], self.textColor[2], self.textColor[3], self.textColor[4])
  love.graphics.printf(self.text, button.x - button.width / 2, textY, button.width, "center")
  love.graphics.setColor(1, 1, 1, 1)
end

function TextButton:isMouseOver()
  return self.button:isMouseOver()
end

function TextButton:mousepressed(x, y, button)
  return self.button:mousepressed(x, y, button)
end

function TextButton:mousereleased(x, y, button)
  return self.button:mousereleased(x, y, button)
end

function TextButton:touchpressed(id, x, y)
  return self.button:touchpressed(id, x, y)
end

function TextButton:touchmoved(id, x, y)
  return self.button:touchmoved(id, x, y)
end

function TextButton:touchreleased(id, x, y)
  return self.button:touchreleased(id, x, y)
end

function TextButton:cancelTouch()
  self.button:cancelTouch()
end
