----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.soundManager")

----------------------------------------
-- Entidade SFX
----------------------------------------

SoundSFX = {}
SoundSFX.__index = SoundSFX
SoundSFX.type = "SoundSFX"

function SoundSFX.new(name, path, category)
  local self = setmetatable({}, SoundSFX)

  self.name = name
  self.source = love.audio.newSource(path, "static")
  self.instances = {}
  self.category = category

  return self
end

function SoundSFX:update()
  for i = #self.instances, 1, -1 do
    local instance = self.instances[i]
    if not instance:isPlaying() then
      table.remove(self.instances, i)
    end
  end
end

function SoundSFX:play()
  local clone = self.source:clone()

  table.insert(self.instances, clone)
  clone:play()

  return clone
end

function SoundSFX:stop()
  for _, instance in ipairs(self.instances) do
    instance:stop()
  end
end
