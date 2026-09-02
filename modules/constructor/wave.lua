----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.utils.utils")
require("modules.entities.wave")
require("modules.entities.spawner")
require("modules.constructor.enemy")
require("modules.system.shots")
require("modules.utils.types")

----------------------------------------
-- Waves
----------------------------------------

function randomPosOutside()
    local startX = VIRTUAL_WIDTH + 50
    local startY = math.random(VIRTUAL_HEIGHT / 5, VIRTUAL_HEIGHT * 5 / 6)
    return startX, startY
end

function randomPosInside()
    local startX = math.random(VIRTUAL_WIDTH * 2 / 5, VIRTUAL_WIDTH - 50)
    local startY = math.random(VIRTUAL_HEIGHT / 4, VIRTUAL_HEIGHT * 3 / 4)
    return startX, startY
end

local function spawnCatSwimmer(vx)
    local startX, startY = randomPosOutside()
    newCatSwimmer(startX, startY, vx)
end

local function spawnShooterEnemy()
    local startX, startY = randomPosOutside()
    newShooterEnemy(startX, startY)
end

local function spawnTankEnemy(vx)
    local startX, startY = randomPosOutside()
    newTankEnemy(startX, startY, vx)
end

local function spawnCatMage(vx)
    local startX, startY = randomPosInside()
    newCatMage(startX, startY, vx)
end

local function spawnCatBox()
    local startX, startY = randomPosOutside()
    newCatBox(startX, startY)
end

local function spawnPufferCat(vx)
    local startX, startY = randomPosOutside()
    newPufferCat(startX, startY, vx)
end

function initWave1()
    local spawners = {
        Spawner.new(CAT_BOX, function() spawnCatBox() end, 3, 1, 30, 1),
        Spawner.new(PUFFER_CAT, function() spawnPufferCat() end, 3, 1, 30, 1),
        -- Spawner.new(SHOOTER_ENEMY, function() spawnShooterEnemy() end, 3, 2, 30, 2),
        -- Spawner.new(SHOOTER_ENEMY, function() spawnShooterEnemy() end, 1.5, 30, 30, 4),

    }
    local wave1 = Wave.new("Wave 1", 30, spawners)
    return wave1
end

function initWave2()
    local spawners = {
        Spawner.new(SHOOTER_ENEMY, function() spawnShooterEnemy() end, 2.5, 5, 40, 3),
        Spawner.new(CAT_SWIMMER, function() spawnCatSwimmer() end, 2.5, 20, 80, 2),
        Spawner.new(SHOOTER_ENEMY, function() spawnShooterEnemy() end, 2, 40, 60, 4)
    }
    local wave2 = Wave.new("Wave 2", 30, spawners)

    return wave2
end

function initWave3()
    local spawners = {
        Spawner.new(SHOOTER_ENEMY, function() spawnShooterEnemy() end, 2, 2, 100, 4),
        Spawner.new(CAT_SWIMMER, function() spawnCatSwimmer(1.3) end, 2, 5, 60, 2),
        Spawner.new(CAT_SWIMMER, function() spawnCatSwimmer(1.3) end, 1.5, 60, 40, 3),
    }
    local wave3 = Wave.new("Wave 3", 30, spawners)
    return wave3
end

function initWave4()
    local spawners = {
        Spawner.new(CAT_SWIMMER, function()
            spawnCatSwimmer()
            spawnCatSwimmer()
        end, 4, 0, 120, 4),
        Spawner.new(SHOOTER_ENEMY, function() spawnShooterEnemy() end, 1.2, 5, 45, 5),
        Spawner.new(SHOOTER_ENEMY, function() spawnShooterEnemy() end, 1, 50, 70, 8)
    }
    local wave4 = Wave.new("Wave 4", 30, spawners)
    return wave4
end

function initWave5()
    local spawners = {
        Spawner.new(SHOOTER_ENEMY, function() spawnShooterEnemy() end, 1, 0, 80, 6),
        Spawner.new(TANK_ENEMY, function() spawnTankEnemy() end, 3, 10, 120, 1),
        Spawner.new(CAT_SWIMMER, function() spawnCatSwimmer(1.2) end, 1.5, 15, 80, 2),
        Spawner.new(CAT_SWIMMER, function() spawnCatSwimmer(0.5) end, 1, 7, 100, 4),
        Spawner.new(SHOOTER_ENEMY, function() spawnShooterEnemy() end, 1, 80, 40, 8)
    }

    local wave5 = Wave.new("Wave 5", 60, spawners)
    return wave5
end

function initWave6()
    local spawners = {
        Spawner.new(TANK_ENEMY, function() spawnTankEnemy() end, 1.5, 0, 120, 3),
        Spawner.new(CAT_SWIMMER, function() spawnCatSwimmer(0.8) end, 1, 10, 80, 10),
        Spawner.new(CAT_SWIMMER, function() spawnCatSwimmer(0.8) end, 1, 90, 30, 15)
    }
    local wave6 = Wave.new("Wave 6", 30, spawners)
    return wave6
end

function initWave7()
    local spawners = {
        Spawner.new(SHOOTER_ENEMY, function() spawnShooterEnemy() end, 1, 0, 130, 16),
        Spawner.new(TANK_ENEMY, function() spawnTankEnemy() end, 2, 30, 90, 5),
        Spawner.new(CAT_SWIMMER, function()
            spawnCatSwimmer(0.5)
            spawnCatSwimmer(0.45)
            spawnCatSwimmer(0.55)
        end, 5, 10, 130),
    }
    local wave7 = Wave.new("Wave 7", 30, spawners)
    return wave7
end

function initWave8()
    local spawners = {
        Spawner.new(SHOOTER_ENEMY, function() spawnShooterEnemy() end, 1.3, 0, 130, 8),
        Spawner.new(TANK_ENEMY, function() spawnTankEnemy(1.2) end, 1.7, 0, 60, 3),
        Spawner.new(TANK_ENEMY, function() spawnTankEnemy(1.2) end, 1.5, 60, 80, 6),
        Spawner.new(CAT_SWIMMER, function()
            spawnCatSwimmer()
            spawnCatSwimmer(0.8)
        end, 3, 10, 120, 8),
    }
    local wave8 = Wave.new("Wave 8", 30, spawners)
    return wave8
end

function initWave9()
    local spawners = {
        Spawner.new(SHOOTER_ENEMY, function() spawnShooterEnemy() end, 1.5, 0, 140, 12),
        Spawner.new(TANK_ENEMY, function() spawnTankEnemy() end, 2, 3, 130, 5),
        Spawner.new(CAT_SWIMMER, function() spawnCatSwimmer(1.5) end, 2, 15, 125, 6)
    }
    local wave9 = Wave.new("Wave 9", 30, spawners)
    return wave9
end

function initWave10()
    local spawners = {
        Spawner.new(TANK_ENEMY, function() spawnTankEnemy() end, 1.8, 0, 120, 4),
        Spawner.new(SHOOTER_ENEMY, function() spawnShooterEnemy() end, 2.2, 0, 140, 8),
        Spawner.new(CAT_SWIMMER, function()
            spawnCatSwimmer(0.7)
            spawnCatSwimmer(0.6)
        end, 1, 30, 100, 6),
        Spawner.new(CAT_MAGE, function() spawnCatMage(1) end, 1.5, 50, 55, 2)
    }
    local wave10 = Wave.new("Wave 10", 60, spawners)
    return wave10
end

function initWave11()
    local spawners = {
        Spawner.new(SHOOTER_ENEMY, function() spawnShooterEnemy() end, 1.8, 0, 150, 15),
        Spawner.new(CAT_MAGE, function() spawnCatMage(1.5) end, 1, 0, 150, 4),
        Spawner.new(CAT_SWIMMER, function() spawnCatSwimmer(1.1) end, 1, 20, 130, 6),
    }

    local wave11 = Wave.new("Wave 11", 30, spawners)
    return wave11
end

function initWave12()
    local spawners = {
        Spawner.new(CAT_SWIMMER, function()
            spawnCatSwimmer(0.6)
            spawnCatSwimmer(0.4)
            spawnCatSwimmer(0.2)
        end, 1.5, 0, 150, 8),
        Spawner.new(TANK_ENEMY, function() spawnTankEnemy(0.8) end, 1.4, 10, 140, 6),
        Spawner.new(CAT_MAGE, function() spawnCatMage(0.7) end, 1, 0, 15, 4),
    }
    local wave12 = Wave.new("Wave 12", 30, spawners)
    return wave12
end

function initWave13()
    local spawners = {
        Spawner.new(CAT_SWIMMER, function() spawnCatSwimmer(2.2) end, 1.5, 0, 130, 9),
        Spawner.new(SHOOTER_ENEMY, function() spawnShooterEnemy() end, 1.5, 5, 150, 15),
        Spawner.new(CAT_MAGE, function() spawnCatMage(2.5) end, 1, 15, 130, 4)
    }
    local wave13 = Wave.new("Wave 13", 30, spawners)
    return wave13
end

function initWave14()
    local spawners = {
        Spawner.new(CAT_SWIMMER, function() spawnCatSwimmer(2) end, 2, 15, 150, 8),
        Spawner.new(SHOOTER_ENEMY, function() spawnShooterEnemy() end, 2, 0, 150, 15),
        Spawner.new(TANK_ENEMY, function() spawnTankEnemy(1.5) end, 0.5, 10, 180, 6),
        Spawner.new(CAT_MAGE, function() spawnCatMage(5) end, 1, 15, 130, 4)
    }
    local wave14 = Wave.new("Wave 14", 30, spawners)
    return wave14
end

function initWave15()
    local phaseBoss = math.random(0, 1)

    local spawners
    if (phaseBoss < 0.25) then
        spawners = {
            Spawner.new(SHOOTER_ENEMY, function() spawnShooterEnemy() end, 3, 0, 180),
            Spawner.new(SHOOTER_ENEMY, function() spawnShooterEnemy() end, 2, 10, 170),
            Spawner.new(SHOOTER_ENEMY, function() spawnShooterEnemy() end, 1, 30, 150)
        }
    elseif (phaseBoss < 0.5) then
        spawners = {
            Spawner.new(CAT_SWIMMER, function() spawnCatSwimmer(0.8) end, 2.3, 0, 100),
            Spawner.new(CAT_SWIMMER, function() spawnCatSwimmer(0.8) end, 2, 15, 160),
            Spawner.new(CAT_SWIMMER, function() spawnCatSwimmer(0.8) end, 1.8, 100, 80),
        }
    elseif (phaseBoss < 0.75) then
        spawners = {
            Spawner.new(TANK_ENEMY, function() spawnTankEnemy(1.3) end, 2, 0, 70),
            Spawner.new(TANK_ENEMY, function() spawnTankEnemy(1.3) end, 2, 10, 170),
            Spawner.new(TANK_ENEMY, function() spawnTankEnemy(1.3) end, 1.7, 70, 110)
        }
    else
        spawners = {
            Spawner.new(CAT_MAGE, function() spawnCatMage(2) end, 2.3, 0, 60),
            Spawner.new(CAT_MAGE, function() spawnCatMage(1.5) end, 2, 30, 180),
            Spawner.new(CAT_MAGE, function() spawnCatMage(1.5) end, 1.5, 60, 110),
        }
    end
    local wave15 = Wave.new("Wave 15", 60, spawners)
    return wave15
end
