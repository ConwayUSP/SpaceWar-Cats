----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.soundManager")

----------------------------------------
-- Entidade SFX
----------------------------------------

SoundMusic = {}
SoundMusic.__index = SoundMusic
SoundMusic.type = "SoundMusic"

function SoundMusic.new(name, path, category)
  local self = setmetatable({}, SoundMusic)
  self.name = name
  self.source = love.audio.newSource(path, "stream")
  self.category = category
  return self
end

function SoundMusic:play(loop)
  self.source:setLooping(loop or false)
  self.source:play()
end

function SoundMusic:stop()
  self.source:stop()
end

function SoundMusic:pause()
  self.source:pause()
end
