----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.soundManager")

local SFX_ASSETS = {
  morte1 = "assets/sounds/sfx/mortes/mortes-1.wav",
  morte2 = "assets/sounds/sfx/mortes/mortes-2.wav",
  morte3 = "assets/sounds/sfx/mortes/mortes-3.wav",
  tiro1 = "assets/sounds/sfx/tiros/tiros-1.mp3",
  tiro2 = "assets/sounds/sfx/tiros/tiros-2.wav",
  buy1 = "assets/sounds/sfx/buy/buy-1.mp3",
  buy2 = "assets/sounds/sfx/buy/buy-2.mp3",
  select1 = "assets/sounds/sfx/select/select-1.wav",
  evil_laugh = "assets/sounds/sfx/evil_laugh.mp3",
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
  self.instances = {}

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

function SoundSFX:loadAll(manager)
  for name, path in pairs(SFX_ASSETS) do
    local sfxInstance = SoundSFX.new(name, path)
      manager:add(sfxInstance)
  end
end


