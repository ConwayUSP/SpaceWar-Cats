----------------------------------------
-- Importações de Módulos
----------------------------------------

require("modules.engine.uiScenes")
require("modules.UI.life")
require("modules.UI.wave")

----------------------------------------
--- BattleScene
----------------------------------------

function newBattleScene()
    local battleScene = UIScene.new()
    battleScene:add(LifeBarWrapper.new())
    battleScene:add(WaveText.new())
    return battleScene
end