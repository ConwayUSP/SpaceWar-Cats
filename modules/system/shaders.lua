whiteShader = love.graphics.newShader("modules/shaders/white.glsl")
grayscaleProgress = love.graphics.newShader("modules/shaders/grayscale_progress.glsl")

function applyColorShader(drawFunc, color)
  love.graphics.setShader(whiteShader)
  whiteShader:send("fillColor", color or { 1.0, 1.0, 1.0, 1.0 })
  drawFunc()
  love.graphics.setShader()
end