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
    return battleScene
end