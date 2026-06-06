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
function newBasicEnemy(x, y)
    local projConfig = {
        speed = 40000,
        damage = 20,
        size = 10,
    }
    local proj = Projectile.new("enemyproj", moveDirection, nil, eProjectiles, projConfig)

    local function moveBasic(self, dt)
        self.body:setLinearVelocity(0, 10000 * math.cos(self.timer * 4) * dt)
    end
    local config = {
        hp = 150,
        hbSize = 30,
        fireRate = 2,
        shootsUntilCd = 5,
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
        self.body:setLinearVelocity(-300, 0)
    end
    local config = {
        hp = 100,
        hbSize = 40,
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
        self.body:setLinearVelocity(-100, 10000 * math.cos(self.timer * 10) * dt)
    end
    local config = {
        hp = 300,
        hbSize = 40,
        fireRate = 3,
        shootsUntilCd = 5,
        cd = 3
    }
    local customShot = defaultCircularAttackFunc(-1, 1, math.rad(10))
    local enemy = Enemy.new("enemy3", vec(x, y), moveTank, proj, customShot, config)
    return enemy
end