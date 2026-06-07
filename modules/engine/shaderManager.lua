local ShaderManager = {}
ShaderManager.__index = ShaderManager

ShaderManager.active = true
ShaderManager.canvasA = nil
ShaderManager.canvasB = nil

ShaderManager.shaders = {}
ShaderManager.pipeline = {}

ShaderManager.time = 0

function ShaderManager:load(shaderOrder)
  self.canvasA = love.graphics.newCanvas(
    love.graphics.getWidth(),
    love.graphics.getHeight()
  )

  self.canvasB = love.graphics.newCanvas(
    love.graphics.getWidth(),
    love.graphics.getHeight()
  )

  self:loadShaders()

  selfpipeline = {}

  for _, name in ipairs(shaderOrder) do
    table.insert(
        self.pipeline,
        self.shaders[name]
    )
  end
end

function ShaderManager:loadShaders()
  self.shaders.crt = love.graphics.newShader("modules/shaders/crt.glsl")
  self.shaders.crt:send("distortionFactor", {1.04, 1.06})
  self.shaders.crt:send("scaleFactor",{1.02, 1.05})
  self.shaders.crt:send("feather",0.03)

  self.shaders.scanlines = love.graphics.newShader("modules/shaders/scanlines.glsl")
  self.shaders.scanlines:send("width", 3)
  self.shaders.scanlines:send("thickness", 2.0)
  self.shaders.scanlines:send("opacity", 0.25)
  self.shaders.scanlines:send("color", {0.0, 0.0, 0.0})
end

function ShaderManager:resize(w, h)
  self.canvasA = love.graphics.newCanvas(w, h)
  self.canvasB = love.graphics.newCanvas(w, h)
end

function ShaderManager:update(dt)
  self.time = self.time + dt

  self.shaders.scanlines:send("phase", 8*self.time)
end

function ShaderManager:toggle()
  self.active = not self.active
end

function ShaderManager:begin()
  if not self.active then
      return
  end

  love.graphics.setCanvas(self.canvasA)
  love.graphics.clear()
end

function ShaderManager:finish()
  if not self.active then
    return
  end
  
  love.graphics.setCanvas()
end

function ShaderManager:draw()
  if not self.active then
    return
  end

  local source = self.canvasA
  local target = self.canvasB

  for _, shader in ipairs(self.pipeline) do

    love.graphics.setCanvas(target)
    love.graphics.clear()

    love.graphics.setShader(shader)
    love.graphics.draw(source)

    love.graphics.setShader()
    love.graphics.setCanvas()

    source, target = target, source
  end

  love.graphics.draw(source)
end

return ShaderManager