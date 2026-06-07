----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.utils.utils")
require("modules.entities.wave")
require("modules.entities.spawner")
require("modules.constructor.enemy")
require("modules.system.shots")

----------------------------------------
-- Waves
----------------------------------------
function initWave1()
    local spawners = {
        Spawner.new(
        function()
            local startX = VIRTUAL_WIDTH + 50
            local startY = math.random(VIRTUAL_HEIGHT / 3, VIRTUAL_HEIGHT * 2 / 3)
            newCatSwimmer(startX, startY)
        end, 1.5, 0),
        Spawner.new(function()
            local startX = VIRTUAL_WIDTH + 50
            local startY = math.random(VIRTUAL_HEIGHT / 3, VIRTUAL_HEIGHT * 2 / 3)
            newShooterEnemy(startX, startY)
        end, 5, 3)
    }
    local wave1 = Wave.new("Wave 1", 20, spawners)
    return wave1
end

function initWave2()
    local spawners = {
        Spawner.new(
        function()
            local startX = VIRTUAL_WIDTH + 50
            local startY = math.random(VIRTUAL_HEIGHT / 3, VIRTUAL_HEIGHT * 2 / 3)
            newCatSwimmer(startX, startY)
        end, 1.4, 0),
        Spawner.new(function()
            local startX = VIRTUAL_WIDTH + 50
            local startY = math.random(VIRTUAL_HEIGHT / 3, VIRTUAL_HEIGHT * 2 / 3)
            newShooterEnemy(startX, startY)
        end, 4.2, 3)
    }
    local wave2 = Wave.new("Wave 2", 30, spawners)

    return wave2
end
