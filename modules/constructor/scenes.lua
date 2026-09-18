----------------------------------------
-- Importações de Módulos
----------------------------------------

require("modules.engine.uiScenes")
require("modules.UI.life")
require("modules.UI.progress_bar")
require("modules.UI.statsDisplay")
require("modules.UI.interactive")
require("modules.UI.shipSelection")

----------------------------------------
--- BattleScene
----------------------------------------

local battleWidgets = {
    shoot = Interactive.new(40, VIRTUAL_HEIGHT - 40, 64, 64, nil, "shoot", 
    function(self)
        local image = p1.spaceship.weapon.image
        love.graphics.draw(image, self.button.x, self.button.y, 0, 2, 2, image:getWidth() / 2, image:getHeight() / 2)
    end, function()
        p1:beginShoot()
    end, function()
        p1:releaseShoot()
    end, function()
        return p1.spaceship:getCooldownPercent()
    end),

    special = Interactive.new(105, VIRTUAL_HEIGHT - 40, 48, 48, 
    function()
        p1:activateSuper()
    end, "special", 
    function(self)
        -- TODO: renderizar imagem do SUPER
    end, nil, nil, 
    function()
        return p1.spaceship:getSuperCooldownPercent()
    end)
}

function newMenuScene()
    local menuScene = UIScene.new()

    menuScene:add(battleWidgets.shoot)
    menuScene:add(battleWidgets.special)

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

function newShipSelectionScene()
    local scene = UIScene.new()
    local title = Text.new(
        "CHOOSE YOUR SHIP",
        22,
        {1, 1, 1, 1},
        vec(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 8),
        0,
        true
    )

    scene:addText(title)
    scene.selection = ShipSelectionUI.new(function(spaceshipData)
        p1:setSpaceship(spaceshipData.constructor(p1))
        SetGameCtx(CTX.BATTLE)
    end)
    scene:add(scene.selection)

    return scene
end

function newBattleScene()
    local battleScene = UIScene.new()
    battleScene:add(LifeBarWrapper.new())
    battleScene:add(battleWidgets.shoot)
    battleScene:add(battleWidgets.special)

    
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
    battleScene:add(WaveProgressBar.new(vec(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT - 40), 100, 4))
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
