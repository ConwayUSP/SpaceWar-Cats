----------------------------------------
-- Importações de Módulos
----------------------------------------

require("modules.engine.uiScenes")
require("modules.UI.life")
require("modules.UI.statsDisplay")

----------------------------------------
--- BattleScene
----------------------------------------

function newMenuScene()
    local menuScene = UIScene.new()
    local txt = Text.new(
        "Press Escape for Settings",
        12,
        { 1, 1, 1, 1 },
        vec(VIRTUAL_WIDTH - 180, VIRTUAL_HEIGHT - 20),
        0,
        false,
        math.huge,
        function (self)
            self.scale = 1 + math.sin(love.timer.getTime() * 2.2) * 0.01
            self.color[4] = 0.6 + math.sin(love.timer.getTime() * 3) * 0.2
        end
    )
    menuScene:addText(txt)
    return menuScene
end

function newBattleScene()
    local battleScene = UIScene.new()
    battleScene:add(LifeBarWrapper.new())
    local txt =  Text.new(
        "WAVE ",
        24,
        { 1, 1, 1, 0.8 },
        vec(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT - 20),
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
        vec(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 6),
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

function newDeathScene()
    local deathScene = UIScene.new()
    local txt = Text.new(
        "YOU DIED",
        48,
        { 1, 0.2, 0.2, 1 },
        vec(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2 - 50),
        0,
        true,
        nil,
        function (self)
            self.rotation = math.sin(love.timer.getTime() * 1.5) * 0.01
            self.scale = 1 + math.sin(love.timer.getTime() * 2.2) * 0.01
        end
    )
    deathScene:addText(txt)
    txt = Text.new(
        checkMobile() and "Tap to try again" or "Press Space to try again",
        14,
        { 1, 1, 1, 0.8 },
        vec(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2 - 25),
        0,
        true,
        nil,
        function (self)
            self.scale = 1 + math.sin(love.timer.getTime() * 2.2) * 0.01
            self.color[4] = 0.8 + math.sin(love.timer.getTime() * 3) * 0.2
        end
    )
    deathScene:addText(txt)

    deathScene:add(StatsDisplay.new(runStats.stats, vec(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2 + 20), 300))
    return deathScene
end

function newWinScene()
    local scene = UIScene.new()
    local txt = Text.new(
        "YOU WON",
        48,
        { 0.2, 1, 0.2, 1 },
        vec(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2 - 50),
        0,
        true,
        nil,
        function (self)
            self.rotation = math.sin(love.timer.getTime() * 1.5) * 0.01
            self.scale = 1 + math.sin(love.timer.getTime() * 2.2) * 0.01
        end
    )
    scene:addText(txt)
    txt = Text.new(
        checkMobile() and "Tap to try again" or "Press Space to try again",
        14,
        { 1, 1, 1, 0.8 },
        vec(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2 - 25),
        0,
        true,
        nil,
        function (self)
            self.scale = 1 + math.sin(love.timer.getTime() * 2.2) * 0.01
            self.color[4] = 0.8 + math.sin(love.timer.getTime() * 3) * 0.2
        end
    )
    scene:addText(txt)

    scene:add(StatsDisplay.new(runStats.stats, vec(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2 + 20), 300))
    return scene
end

function newPauseScene()
    local pauseScene = UIScene.new()
    local txt = Text.new(
        "SETTINGS",
        26,
        { 1, 1, 1, 1 },
        vec(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 6),
        0,
        true,
        math.huge,
        function (self)
            self.rotation = math.sin(love.timer.getTime() * 1.5) * 0.01
            self.scale = 1 + math.sin(love.timer.getTime() * 2.2) * 0.01
        end,
        nil,
        "center"
    )
    pauseScene:addText(txt)
    return pauseScene
end