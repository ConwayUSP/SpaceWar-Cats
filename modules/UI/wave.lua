----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.waveManager")

----------------------------------------
-- Classe WaveText
----------------------------------------

WaveText = {}
WaveText.__index = WaveText
WaveText.type = "WaveText"

function WaveText.new()
  local self = setmetatable({}, WaveText)
  self.text = Text.new(
    "WAVE ",
    24,
    { 1, 1, 1, 0.8 },
    { VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT - 20 },
    0,
    true,
    math.huge,
    function(text)
      text.content = "WAVE " .. waveManager.currentWaveIndex
    end,
    nil
  )
  return self
end

function WaveText:update(dt)
  updateTexts({ self.text }, dt)
end

function WaveText:draw()
  drawTexts({ self.text })
end