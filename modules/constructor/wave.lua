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

function randomPosOutside()
    local startX = VIRTUAL_WIDTH + 50
    local startY = math.random(VIRTUAL_HEIGHT / 4, VIRTUAL_HEIGHT * 3 / 4)
    return startX, startY
end

function randomPosInside()
    local startX = math.random(VIRTUAL_WIDTH * 2 / 5, VIRTUAL_WIDTH - 50)
    local startY = math.random(VIRTUAL_HEIGHT / 4, VIRTUAL_HEIGHT * 3 / 4)
    return startX, startY
end

function initWave1()
    local spawners = {
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newCatSwimmer(startX, startY)
        end, 5, 0),
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newShooterEnemy(startX, startY)
        end, 3, 5)
    }
    local wave1 = Wave.new("Wave 1", 30, spawners)
    return wave1
end

function initWave2()
    local spawners = {
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newCatSwimmer(startX, startY, 1.2)
        end, 3, 5),
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newShooterEnemy(startX, startY)
        end, 3, 0)
    }
    local wave2 = Wave.new("Wave 2", 30, spawners)

    return wave2
end

function initWave3()
    local spawners = {
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newShooterEnemy(startX, startY)
        end, 2, 10),
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newCatSwimmer(startX, startY, 1.1)
        end, 3, 5),
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newCatSwimmer(startX, startY, 1.3)
        end, 2, 15),
    }
    local wave3 = Wave.new("Wave 3", 30, spawners)
    return wave3
end

function initWave4()
    local spawners = {
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newCatSwimmer(startX, startY, 0.5)
            startX, startY = randomPosOutside()
            newCatSwimmer(startX, startY, 0.5)
        end, 2, 10),
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newShooterEnemy(startX, startY)
        end, 1.5, 0),
    }
    local wave4 = Wave.new("Wave 4", 30, spawners)
    return wave4
end

function initWave5()
    local spawners = {
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newShooterEnemy(startX, startY)
        end, 6, 0),
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newTankEnemy(startX, startY)
        end, 3, 0),
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newCatSwimmer(startX, startY, 1.2)
        end, 3, 15),
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newTankEnemy(startX, startY)
        end, 2, 40),
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newCatSwimmer(startX, startY, 0.5)
        end, 3, 40),
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newShooterEnemy(startX, startY)
        end, 5, 45),
    }

    local wave5 = Wave.new("Wave 5", 60, spawners)
    return wave5
end

function initWave6()
    local spawners = {
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newTankEnemy(startX, startY, 2.5)
        end, 2, 0),
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newCatSwimmer(startX, startY, 0.8)
        end, 2.5, 10),
    }
    local wave6 = Wave.new("Wave 6", 30, spawners)
    return wave6
end

function initWave7()
    local spawners = {
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newShooterEnemy(startX, startY)
        end, 1.5, 0),
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newTankEnemy(startX, startY)
        end, 3, 15),
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newCatSwimmer(startX, startY, 0.3)
            startX, startY = randomPosOutside()
            newCatSwimmer(startX, startY, 0.3)
            startX, startY = randomPosOutside()
            newCatSwimmer(startX, startY, 0.3)
        end, 2, 5),
    }
    local wave7 = Wave.new("Wave 7", 30, spawners)
    return wave7
end

function initWave8()
    local spawners = {
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newTankEnemy(startX, startY, 3)
        end, 4, 0),
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newCatSwimmer(startX, startY)
            startX, startY = randomPosOutside()
            newCatSwimmer(startX, startY)
        end, 2, 10),
    }
    local wave8 = Wave.new("Wave 8", 30, spawners)
    return wave8
end

function initWave9()
    local spawners = {
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newTankEnemy(startX, startY, 0.8)
        end, 1.5, 0),
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newShooterEnemy(startX, startY)
        end, 3, 10),
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newCatSwimmer(startX, startY, 2.5)
        end, 5, 15),
    }
    local wave9 = Wave.new("Wave 9", 30, spawners)
    return wave9
end

function initWave10()
    local spawners = {
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newTankEnemy(startX, startY)
        end, 5, 0),
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newShooterEnemy(startX, startY)
        end, 4, 10),
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newCatSwimmer(startX, startY, 0.3)
            startX, startY = randomPosOutside()
            newCatSwimmer(startX, startY, 0.3)
        end, 3, 5),
        Spawner.new(function()
            local startX, startY = randomPosInside()
            newCatMage(startX, startY, 5)
        end, 6, 15)
    }
    local wave10 = Wave.new("Wave 10", 60, spawners)
    return wave10
end

function initWave11()
    local spawners = {
        Spawner.new(function()
            local startX, startY = randomPosInside()
            newCatMage(startX, startY, 2)
        end, 3, 5),
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newCatSwimmer(startX, startY, 1.5)
        end, 3, 0),
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newCatSwimmer(startX, startY, 1.5)
        end, 3, 15)
    }

    local wave11 = Wave.new("Wave 11", 30, spawners)
    return wave11
end

function initWave12()
    local spawners = {
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newCatSwimmer(startX, startY, 0.6)
            startX, startY = randomPosOutside()
            newCatSwimmer(startX, startY, 0.4)
            startX, startY = randomPosOutside()
            newCatSwimmer(startX, startY, 0.2)
        end, 5, 10),
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newTankEnemy(startX, startY, 2)
        end, 6, 0),
        Spawner.new(function()
            local startX, startY = randomPosInside()
            newCatMage(startX, startY, 1.5)
        end, 2.5, 15),
    }
    local wave12 = Wave.new("Wave 12", 30, spawners)
    return wave12
end

function initWave13()
    local spawners = {
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            startX, startY = randomPosOutside()
            newCatSwimmer(startX, startY, 1.8)
        end, 5, 10),
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newShooterEnemy(startX, startY)
        end, 3, 0),
        Spawner.new(function()
            local startX, startY = randomPosInside()
            newCatMage(startX, startY, 2)
        end, 2, 15)
    }
    local wave13 = Wave.new("Wave 13", 30, spawners)
    return wave13
end

function initWave14()
    local spawners = {
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            startX, startY = randomPosOutside()
            newCatSwimmer(startX, startY, 2.5)
        end, 5, 20),
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newShooterEnemy(startX, startY)
        end, 4, 0),
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newTankEnemy(startX, startY, 2.5)
        end, 5, 15),
        Spawner.new(function()
            local startX, startY = randomPosInside()
            newCatMage(startX, startY, 2)
        end, 2, 0)
    }
    local wave14 = Wave.new("Wave 14", 30, spawners)
    return wave14
end

function initWave15()
    local spawners = {
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            startX, startY = randomPosOutside()
            newCatSwimmer(startX, startY, 1.5)
        end, 7, 0),
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            startX, startY = randomPosOutside()
            newCatSwimmer(startX, startY, 2)
        end, 15, 30),
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            startX, startY = randomPosOutside()
            newCatSwimmer(startX, startY, 2.5)
        end, 5, 45),
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newShooterEnemy(startX, startY)
        end, 5, 25),
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newTankEnemy(startX, startY, 0.5)
        end, 8, 20),
        Spawner.new(function()
            local startX, startY = randomPosOutside()
            newCatMage(startX, startY, 1)
        end, 8, 0),
    }
    local wave15 = Wave.new("Wave 15", 60, spawners)
    return wave15
end
