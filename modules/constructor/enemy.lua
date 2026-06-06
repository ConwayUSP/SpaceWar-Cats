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
    }
    local proj = Projectile.new("enemyproj", moveDirection, nil, eProjectiles, projConfig)

    local function moveBasic(self, dt)
        local error = (VIRTUAL_WIDTH - 50) - self.body:getX()
        local vx = error * dt * 100
        local vy = 1000 * math.cos(self.timer * math.pi * 0.5) * dt
        self.body:setLinearVelocity(vx, vy)
    end
    local config = {
        hp = 100,
        size = 12,
        fireRate = 1,
        shootsUntilCd = 2,
        cd = 2
    }
    local enemy = Enemy.new("enemy1", vec(x, y), moveBasic, proj, nil, config)
    return enemy
end

----------------------------------------
-- INIMIGO 2
----------------------------------------
function newFastEnemy(x, y)
    local function moveFast(self, dt)
        self.body:setLinearVelocity(-15000 * dt, 0)
    end
    local config = {
        hp = 100,
        size = 12,
        fireRate = 3,
        shootsUntilCd = 5,
        cd = 3
    }
    local enemy = Enemy.new("enemy2", vec(x, y), moveFast, nil, nil, config)
    return enemy
end


----------------------------------------
-- INIMIGO 3
----------------------------------------
function newTankEnemy(x, y)
    local projConfig = {
        speed = 30000,
        damage = 30,
        size = 10
    }
    local proj = Projectile.new("enemyproj", moveDirection, nil, eProjectiles, projConfig)
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
    local enemy = Enemy.new("enemy3", vec(x, y), moveTank, proj, customShot, config)
    return enemy
end