whiteShader = love.graphics.newShader("modules/shaders/white.glsl")

function applyWhiteShader(drawFunc)
  love.graphics.setShader(whiteShader)
  whiteShader:send("fillColor", { 1, 1, 1, 1.0 })
  drawFunc()
  love.graphics.setShader()
end