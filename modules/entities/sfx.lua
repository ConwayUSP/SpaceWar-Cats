----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.soundManager")

local SFX_ASSETS = {
  morte1 = "assets/audios/sounds-effects/mortes/mortes-1.wav",
  morte2 = "assets/audios/sounds-effects/mortes/mortes-2.wav",
  morte3 = "assets/audios/sounds-effects/mortes/mortes-3.wav",
  tiro1 = "assets/audios/sounds-effects/tiros/tiros-1.wav",
  tiro2 = "assets/audios/sounds-effects/tiros/tiros-2.wav",
  tiro3 = "assets/audios/sounds-effects/tiros/tiros-3.wav"
}

----------------------------------------
-- Entidade SFX
----------------------------------------

SoundSFX = {}
SoundSFX.__index = SoundSFX
SoundSFX.type = "SoundSFX"

function SoundSFX.new(name, path)
  local self = setmetatable({}, SoundSFX)
  self.name = name
  self.source = love.audio.newSource(path, "static")
  return self
end

function SoundSFX:play()
  local clone = self.source:clone()
  love.audio.play(clone)
end

function SoundSFX:loadAll(manager)
  for name, path in pairs(SFX_ASSETS) do
    local sfxInstance = SoundSFX.new(name, path)
      manager:add(sfxInstance)
  end
end


