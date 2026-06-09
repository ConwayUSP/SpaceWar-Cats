----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.utils.utils")
require("modules.entities.enemy")
require("modules.constructor.projectile")
require("modules.system.shots")


function hpMultipler()
    wave = WaveManager.currentWaveIndex
    return (1 + (wave * 0.05) + math.exp(wave - 5))
end

----------------------------------------
-- INIMIGO 1
----------------------------------------
function newShooterEnemy(x, y)
    local projConfig = {
        speed = 15000,
        damage = 20,
        size = 2,
        hb = {
            type = "circle",
            radius = 3
        },
        sound = "tiro1"
    }
    local proj = Projectile.new("blaster-ball", moveDirection, nil, eProjectiles, projConfig)

    local function move(self, dt)
        local error = (VIRTUAL_WIDTH - 50) - self.body:getX()
        local vx = error * dt * 100
        local vy = 1000 * math.cos(self.timer * math.pi * 0.2) * dt
        self.body:setLinearVelocity(vx, vy)
    end
    local config = {
        hp = 50 * hpMultipler(),
        size = 12,
        fireRate = 3,
        shootsUntilCd = 3,
        cd = 4
    }
    local enemy = Enemy.new("drone", vec(x, y), move, proj, nil, config)
    local flyingConfig = newAnimSetting(4, { width = 32, height = 32 }, 0.1, true, 1)
    enemy:addAnimations(flyingConfig)
    return enemy
end

----------------------------------------
-- INIMIGO 2
----------------------------------------
function newCatSwimmer(x, y, vx)
    vx = vx or 1
    local function move(self, dt)
        local f = -math.cos(self.timer * math.pi) + 1.2
        self.body:setLinearVelocity(-7000 * dt * f * vx, 0)
    end
    local config = {
        hp = 40 * hpMultipler(),
        size = 12,
        fireRate = 3,
        shootsUntilCd = 5,
        cd = 3,
        hb = {
            type = "rectangle",
            width = 22,
            height = 18
        }
    }
    local enemy = Enemy.new("swimmer", vec(x, y), move, nil, nil, config)
    local flyingConfig = newAnimSetting(9, { width = 32, height = 32 }, 0.1, true, 1)
    enemy:addAnimations(flyingConfig)
    return enemy
end

----------------------------------------
-- INIMIGO 3
----------------------------------------
function newTankEnemy(x, y)
    local projConfig = {
        speed = 8000,
        damage = 30,
        size = 10,
        hb = {
            type = "circle",
            radius = 3
        },
        sound = "tiro2"
    }
    local proj = Projectile.new("blaster-ball", moveDirection, nil, eProjectiles, projConfig)
    local function move(self, dt)
        local vx, vy = self.body:getLinearVelocity()
        vy = vy + math.cos(self.timer) * 62.5 * dt
        self.body:setLinearVelocity(-16, vy)
    end
    local config = {
        hp = 70 * hpMultipler(),
        size = 20,
        fireRate = 1,
        shootsUntilCd = 3,
        cd = 4
    }
    local customShot = defaultConicalAttackFunc(-1, 1, math.rad(10))
    local flyingConfig = newAnimSetting(4, { width = 32, height = 32 }, 0.1, true, 1)
    local enemy = Enemy.new("drone", vec(x, y), move, proj, customShot, config)
    enemy:addAnimations(flyingConfig)
    return enemy
end

----------------------------------------
-- INIMIGO 4
----------------------------------------

function newCatMage(x, y, cd)
    local projConfig = {
        speed = 5000,
        damage = 20,
        size = 5,
        hb = {
            type = "circle",
            radius = 3
        },
        turnSpeed = math.rad(360) * 0.8
    }
    local proj = Projectile.new("blaster-ball", moveCircular, nil, eProjectiles, projConfig)
    local cdTimer = cd
    local function move(self, dt)
        cdTimer = cdTimer - dt
        if cdTimer <= 0 then
            x = math.random(100, SCREEN_WIDTH - 100)
            y = math.random(50, 60)
            self.body:setPosition(x, y)
            cdTimer = cd
        end
    end
    local config = {
        hp = 150 * hpMultipler(),
        size = 12,
        fireRate = 3,
        shootsUntilCd = 1,
        cd = 3,
        hb = {
            type = "rectangle",
            width = 22,
            height = 18
        }
    }
    local enemy = Enemy.new("mage", vec(x, y), move, proj, nil, config)
    local flyingConfig = newAnimSetting(6, { width = 32, height = 32 }, 0.1, true, 1)
    enemy:addAnimations(flyingConfig)
    return enemy
end
