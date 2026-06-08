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

function SoundMusic.new(name, path)
  local self = setmetatable({}, SoundMusic)
  self.name = name
  self.source = love.audio.newSource(path, "stream")
  return self
end

function SoundMusic:play()
  local clone = self.source:clone()
  love.audio.play(clone)
end
