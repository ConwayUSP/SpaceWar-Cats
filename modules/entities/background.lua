local Background = {}
Background.__index = Background
Background.type = "Background"

function Background:load()
  local path = pngPathFormat({ "assets", "animations", "background", "space" })
  self.state = IDLE
  addAnimation(self, path, self.state, newAnimSetting(5, { width = VIRTUAL_WIDTH, height = VIRTUAL_HEIGHT }, 0.2, true, 1))
end

function Background:update(dt)
  self.animations[self.state]:update(dt)
end

function Background:draw()
  love.graphics.setColor(1, 1, 1, 0.8)

  local animation = self.animations[self.state]
  local quad = animation.frames[animation.currFrame]
  love.graphics.draw(self.spriteSheets[self.state], quad, 0, 0)

  love.graphics.setColor(1, 1, 1, 1)

end

return Background