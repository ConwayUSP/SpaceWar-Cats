----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.utils.utils")
require("modules.entities.enemy")
require("modules.constructor.projectile")
require("modules.system.shots")

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
        }
    }
    local proj = Projectile.new("blaster-ball", moveDirection, nil, eProjectiles, projConfig)

    local function move(self, dt)
        local error = (VIRTUAL_WIDTH - 50) - self.body:getX()
        local vx = error * dt * 100
        local vy = 1000 * math.cos(self.timer * math.pi * 0.2) * dt
        self.body:setLinearVelocity(vx, vy)
    end
    local config = {
        hp = 100,
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
function newCatSwimmer(x, y)
    local function move(self, dt)
        local f = -math.cos(self.timer * math.pi) + 1.2
        self.body:setLinearVelocity(-7000 * dt * f, 0)
    end
    local config = {
        hp = 100,
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
    local enemy = Enemy.new("cat-swimmer", vec(x, y), move, nil, nil, config)
    local flyingConfig = newAnimSetting(9, { width = 32, height = 32 }, 0.1, true, 1)
    enemy:addAnimations(flyingConfig)
    return enemy
end


----------------------------------------
-- INIMIGO 3
----------------------------------------
function newTankEnemy(x, y)
    local projConfig = {
        speed = 30000,
        damage = 30,
        size = 10,
        hb = {
            type = "circle",
            radius = 3
        }
    }
    local proj = Projectile.new("blaster-ball", moveDirection, nil, eProjectiles, projConfig)
    local function moveTank(self, dt)
        self.body:setLinearVelocity(-10000 * dt, 10000 * math.cos(self.timer * 10) * dt)
    end
    local config = {
        hp = 300,
        size = 20,
        fireRate = 3,
        shootsUntilCd = 5,
        cd = 3
    }
    local customShot = defaultCircularAttackFunc(-1, 1, math.rad(10))
    local flyingConfig = newAnimSetting(4, { width = 32, height = 32 }, 0.1, true, 1)
    local enemy = Enemy.new("tank", vec(x, y), moveTank, proj, customShot, config)
    enemy:addAnimations(flyingConfig)
    return enemy
end