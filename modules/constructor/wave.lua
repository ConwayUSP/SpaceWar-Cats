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
            end, 10, 0),
        Spawner.new(function()
            local startX = VIRTUAL_WIDTH + 50
            local startY = math.random(VIRTUAL_HEIGHT / 3, VIRTUAL_HEIGHT * 2 / 3)
            newShooterEnemy(startX, startY)
        end, 4, 5)
    }
    local wave1 = Wave.new("Wave 1", 30, spawners)
    return wave1
end

function initWave2()
    local spawners = {
        Spawner.new(
            function()
                local startX = VIRTUAL_WIDTH + 50
                local startY = math.random(VIRTUAL_HEIGHT / 3, VIRTUAL_HEIGHT * 2 / 3)
                newCatSwimmer(startX, startY, 1.2)
            end, 3, 5),
        Spawner.new(function()
            local startX = VIRTUAL_WIDTH + 50
            local startY = math.random(VIRTUAL_HEIGHT / 10, VIRTUAL_HEIGHT * 3 / 4)
            newShooterEnemy(startX, startY)
        end, 5, 0)
    }
    local wave2 = Wave.new("Wave 2", 30, spawners)

    return wave2
end

function initWave3()
    local spawners = {
        Spawner.new(function()
            local startX = VIRTUAL_WIDTH + 50
            local startY = math.random(VIRTUAL_HEIGHT / 10, VIRTUAL_HEIGHT)
            newShooterEnemy(startX, startY)
        end, 8, 10),
        Spawner.new(function()
            local startX = VIRTUAL_WIDTH + 50
            local startY = math.random(VIRTUAL_HEIGHT / 3, VIRTUAL_HEIGHT * 2 / 3)
            newTankEnemy(startX, startY)
        end, 6, 0)
    }
    local wave3 = Wave.new("Wave 3", 30, spawners)
    return wave3
end

function initWave4()
    local spawners = {
        Spawner.new(function()
            local startX = VIRTUAL_WIDTH + 50
            local startY = math.random(VIRTUAL_HEIGHT / 3, VIRTUAL_HEIGHT * 2 / 3)
            newCatSwimmer(startX, startY - 50, 0.5)
            newCatSwimmer(startX - 50, startY + 50, 0.5)
        end, 10, 5),
        Spawner.new(function()
            local startX = VIRTUAL_WIDTH + 50
            local startY = math.random(VIRTUAL_HEIGHT / 3, VIRTUAL_HEIGHT * 2 / 3)
            newTankEnemy(startX, startY)
        end, 8, 0)
    }
    local wave4 = Wave.new("Wave 4", 30, spawners)
    return wave4
end

function initWave5()
    local spawners = {
        Spawner.new(function()
            newCatMage(200, 200, 3)
        end, 5, 0),
        Spawner.new(function()
            local startX = VIRTUAL_WIDTH + 50
            local startY = math.random(VIRTUAL_HEIGHT / 3, VIRTUAL_HEIGHT * 2 / 3)
            newTankEnemy(startX, startY)
        end, 8, 0)
    }

    local wave5 = Wave.new("Wave 5", 30, spawners)
    return wave5
end

function initWave6()
    local spawners = {
        Spawner.new(function()
            newCatMage(200, 200, 3)
        end, 7, 0),
        Spawner.new(function()
            local startX = VIRTUAL_WIDTH + 50
            local startY = math.random(VIRTUAL_HEIGHT / 3, VIRTUAL_HEIGHT * 2 / 3)
            newTankEnemy(startX, startY)
        end, 10, 0),
        Spawner.new(function()
            local startX = VIRTUAL_WIDTH + 50
            local startY = math.random(VIRTUAL_HEIGHT / 3, VIRTUAL_HEIGHT * 2 / 3)
            newCatSwimmer(startX, startY, 0.8)
        end, 3, 5),
    }
    local wave6 = Wave.new("Wave 6", 30, spawners)
    return wave6
end

function initWave7()
    local spawners = {
        Spawner.new(function()
            local startX = VIRTUAL_WIDTH + 50
            local startY = math.random(VIRTUAL_HEIGHT / 3, VIRTUAL_HEIGHT * 2 / 3)
            newShooterEnemy(startX, startY)
        end, 4, 15),
        Spawner.new(function()
            local startX = VIRTUAL_WIDTH + 50
            local startY = math.random(VIRTUAL_HEIGHT / 3, VIRTUAL_HEIGHT * 2 / 3)
            newTankEnemy(startX, startY)
        end, 7, 0),
        Spawner.new(function()
            local startX = VIRTUAL_WIDTH + 50
            local startY = math.random(VIRTUAL_HEIGHT / 8, VIRTUAL_HEIGHT * 4 / 5)
            newCatSwimmer(startX, startY - 75, 0.3)
            newCatSwimmer(startX - 100, startY + 75, 0.3)
        end, 2, 5),
    }
    local wave7 = Wave.new("Wave 7", 30, spawners)
    return wave7
end

function initWave8()
    local spawners = {
        Spawner.new(function()
            local startX = VIRTUAL_WIDTH + 50
            local startY = math.random(VIRTUAL_HEIGHT / 3, VIRTUAL_HEIGHT * 2 / 3)
            newShooterEnemy(startX, startY)
        end, 4, 10),
        Spawner.new(function()
            local startX = VIRTUAL_WIDTH + 50
            local startY = math.random(VIRTUAL_HEIGHT / 3, VIRTUAL_HEIGHT * 2 / 3)
            newTankEnemy(startX, startY)
        end, 7, 0),
        Spawner.new(function()
            local startX = VIRTUAL_WIDTH + 50
            local startY = math.random(VIRTUAL_HEIGHT / 8, VIRTUAL_HEIGHT * 4 / 5)
            newCatSwimmer(startX, startY - 75, 0.3)
            newCatSwimmer(startX - 100, startY + 75, 0.3)
        end, 2, 5),
        Spawner.new(function()
            local startX = VIRTUAL_WIDTH + 50
            local startY = math.random(VIRTUAL_HEIGHT / 3, VIRTUAL_HEIGHT * 2 / 3)
            newCatMage(startX, startY, 5)
        end, 4, 15)
    }
    local wave8 = Wave.new("Wave 8", 30, spawners)
    return wave8
end

