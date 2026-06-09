----------------------------------------
-- Importações de Módulos
----------------------------------------

require("modules.engine.uiScenes")
require("modules.UI.life")

----------------------------------------
--- BattleScene
----------------------------------------

function newBattleScene()
    local battleScene = UIScene.new()
    battleScene:add(LifeBarWrapper.new())
    local txt =  Text.new(
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
    battleScene:addText(txt)
    return battleScene
end

function newUpgradeScene()
    local upgradeScene = UIScene.new()
    local txt = Text.new(
        "CHOOSE AN UPGRADE",
        22,
        { 1, 1, 1, 1 },
        { VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 6 },
        0,
        true,
        nil,
        function (self)
            self.rotation = math.sin(love.timer.getTime() * 1.5) * 0.01
            self.scale = 1 + math.sin(love.timer.getTime() * 2.2) * 0.01
        end
    )
    upgradeScene:addText(txt)
    return upgradeScene
end