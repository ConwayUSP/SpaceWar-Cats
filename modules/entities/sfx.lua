----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.soundManager")

local SFX_ASSETS = {
  morte1 = "assets/sounds/sfx/mortes/mortes-1.wav",
  morte2 = "assets/sounds/sfx/mortes/mortes-2.wav",
  morte3 = "assets/sounds/sfx/mortes/mortes-3.wav",
  tiro1 = "assets/sounds/sfx/tiros/tiros-1.wav",
  tiro2 = "assets/sounds/sfx/tiros/tiros-2.wav",
  buy1 = "assets/sounds/sfx/buy/buy-1.mp3",
  buy2 = "assets/sounds/sfx/buy/buy-2.mp3",
  select1 = "assets/sounds/sfx/select/select-1.wav",
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


