----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.utils.utils")
require("modules.entities.wave")
require("modules.entities.spawner")
require("modules.constructor.enemy")
require("modules.system.shots")

-- Wave 1:
function addWave1()
    local spawners = {
        Spawner.new(function()
            local startX = VIRTUAL_WIDTH + 50
            local startY = math.random(VIRTUAL_HEIGHT / 4, VIRTUAL_HEIGHT * 3 / 3)
            newFastEnemy(startX, startY)
        end, 1, 0),
        Spawner.new(function()
            local startX = VIRTUAL_WIDTH + 50
            local startY = math.random(VIRTUAL_HEIGHT / 3, VIRTUAL_HEIGHT * 2 / 3)
            newShooterEnemy(startX, startY)
        end, 2, 3)
    }
    local wave1 = Wave.new("Wave 1", 15, spawners)
    return wave1
end

-- Wave 2:
function addWave2()
    local spawners = {

    }
    local wave2 = Wave.new("Wave 2", 20, spawners)

    return wave2
end
