----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.utils.utils")
require("modules.entities.enemy")
require("modules.constructor.projectile")
require("modules.system.shots")
require("modules.utils.types")


function hpMultipler()
    wave = WaveManager.currentWaveIndex
    return (1 + (wave * 0.05) + math.exp(3 * (wave - 14) / wave))
end

----------------------------------------
-- INIMIGO 1
----------------------------------------
function newShooterEnemy(x, y)
    local projConfig = {
        bulletSpeed = 150,
        damage = 20,
        size = 2,
        hb = {
            type = CIRCLE,
            radius = 3
        },
        sound = "tiro1"
    }
    local proj = Projectile.new("blaster-ball", moveDirection, nil, eProjectiles, projConfig)

    local function move(self, dt)
        local vx = -25 * (math.cos(self.timer * math.pi * 0.2) ^ 4)
        local vy = 10 * math.cos(self.timer * math.pi * 0.2)
        self.body:setLinearVelocity(vx, vy)

        -- Clamp position to screen bounds
        local x, y = self.body:getPosition()
        local margin = self.size * 0.5
        y = math.max(margin, math.min(VIRTUAL_HEIGHT - margin, y))
        self.body:setPosition(x, y)
    end
    local config = {
        hp = 50 * hpMultipler(),
        size = 12,
        fireRate = 3,
        shootsUntilCd = 3,
        cd = 4
    }
    local enemy = Enemy.new(SHOOTER_ENEMY, vec(x, y), move, nil, proj, nil, config)
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
        self.body:setLinearVelocity(-45 * f * vx, 0)
    end
    local config = {
        hp = 55 * hpMultipler(),
        size = 12,
        fireRate = 3,
        shootsUntilCd = 5,
        cd = 3,
        hb = {
            type = RECTANGLE,
            width = 22,
            height = 18
        }
    }
    local enemy = Enemy.new(CAT_SWIMMER, vec(x, y), move, nil, nil, nil, config)
    local flyingConfig = newAnimSetting(9, { width = 32, height = 32 }, 0.1, true, 1)
    enemy:addAnimations(flyingConfig)
    return enemy
end

----------------------------------------
-- INIMIGO 3
----------------------------------------
function newTankEnemy(x, y, newVx)
    local projConfig = {
        bulletSpeed = 80,
        damage = 30,
        size = 10,
        hb = {
            type = CIRCLE,
            radius = 3
        },
        sound = "tiro2"
    }
    local moveProj = function(e, dt)
        local vx = -e.speed * (6 ^ (e.timer - 1) + 1)
        e.body:setLinearVelocity(vx, 0)
    end
    local proj = Projectile.new("blaster-ball", moveProj, nil, eProjectiles, projConfig)
    local function move(self, dt)
        local vx, vy = self.body:getLinearVelocity()
        vy = vy + math.cos(self.timer) * .625
        vx = newVx and (-newVx * 15) or -15
        self.body:setLinearVelocity(vx, vy)

        -- Clamp position to screen bounds
        local x, y = self.body:getPosition()
        local margin = self.size * 0.5
        y = math.max(margin, math.min(VIRTUAL_HEIGHT - margin, y))
        self.body:setPosition(x, y)
    end
    local config = {
        hp = 100 * hpMultipler(),
        size = 20,
        fireRate = 1,
        shootsUntilCd = 3,
        cd = 4,
        hb = {
            type = RECTANGLE,
            width = 20,
            height = 25
        },
    }
    local customShot = function(atk, attacker, origin, direction)
        local timer = 0
        local delay = 0.3

        return function(dt)
            local x1, y1 = attacker.body:getPosition()
            if timer == 0 then
                atk:shoot(attacker, addVec(vec(x1, y1), vec(-10, -8)), direction)
            end

            timer = timer + dt
            if timer >= delay then
                atk:shoot(attacker, addVec(vec(x1, y1), vec(-5, -8)), direction)
                return true
            end
            return false
        end
    end
    -- local customShot = defaultConicalAttackFunc(-1, 1, math.rad(10))
    local flyingConfig = newAnimSetting(4, { width = 32, height = 32 }, 0.1, true, 1)
    local enemy = Enemy.new(TANK_ENEMY, vec(x, y), move, nil, proj, customShot, config)
    enemy:addAnimations(flyingConfig)
    return enemy
end

----------------------------------------
-- INIMIGO 4
----------------------------------------

function newCatMage(x, y, cd)
    local projConfig = {
        bulletSpeed = 50,
        damage = 20,
        size = 5,
        hb = {
            type = CIRCLE,
            radius = 3
        },
        turnSpeed = math.rad(360) * 0.8
    }
    local proj = Projectile.new("blaster-ball", moveCircular, nil, eProjectiles, projConfig)


    local cdTimer = cd
    local function move(self, dt)
        self.fadeState = self.fadeState or "fadeIn"
        self.alpha = self.alpha or 0
        self.fadeSpeed = 2
        if self.fadeState == "idle" then
            cdTimer = cdTimer - dt
            if cdTimer <= 0 then
                self.fadeState = "fadeOut"
            else
                local k = 0.4
                local vx = -40 * math.cos(self.timer * math.pi * k) * (math.pi * k)
                local vy = 40 * math.cos(self.timer * math.pi * 2 * k) * (math.pi * 2 * k)
                self.body:setLinearVelocity(vx, vy)

                -- Clamp position to screen bounds
                local x, y = self.body:getPosition()
                local margin = self.size * 0.5
                y = math.max(margin, math.min(VIRTUAL_HEIGHT - margin, y))
                self.body:setPosition(x, y)
            end
        end

        if self.fadeState == "fadeOut" then
            self.body:setLinearVelocity(0, 0)
            self.alpha = self.alpha - (self.fadeSpeed * dt)
            if self.alpha <= 0 then
                self.alpha = 0
                local x1, y1 = randomPosInside()
                self.body:setPosition(x1, y1)
                self.fadeState = "fadeIn"
            end
        elseif self.fadeState == "fadeIn" then
            self.body:setLinearVelocity(0, 0)
            self.alpha = self.alpha + (self.fadeSpeed * dt)
            if self.alpha >= 1 then
                self.alpha = 1
                self.fadeState = "idle"
                cdTimer = cd
            end
        end
    end
    local config = {
        hp = 60 * hpMultipler(),
        size = 12,
        fireRate = 3,
        shootsUntilCd = 1,
        cd = 3,
        hb = {
            type = RECTANGLE,
            width = 20,
            height = 28
        },
        initialAlpha = 0
    }
    local enemy = Enemy.new(CAT_MAGE, vec(x, y), move, nil, proj, nil, config)
    local flyingConfig = newAnimSetting(6, { width = 32, height = 32 }, 0.1, true, 1)
    enemy:addAnimations(flyingConfig)
    return enemy
end

----------------------------------------
-- INIMIGO 5
----------------------------------------
function newCatBox(x, y)
    local function onDeath(self, sx, sy)
        local spawnables = {
            function() newTankEnemy(sx, sy, 1) end,
            function() newCatMage(sx, sy, 3) end,
        }
        local randomSpawn = spawnables[math.random(#spawnables)]
        if (math.random(2) == 1) then
            randomSpawn()
        end
    end

    local function move(self, dt)
        local vx = -45 * (math.cos(self.timer * math.pi * 0.2) ^ 4)
        local vy = 10 * math.cos(self.timer * math.pi * 0.2)
        self.body:setLinearVelocity(vx, vy)

        -- Clamp position to screen bounds
        local x, y = self.body:getPosition()
        local margin = self.size * 0.5
        y = math.max(margin, math.min(VIRTUAL_HEIGHT - margin, y))
        self.body:setPosition(x, y)
    end
    local config = {
        hp = 100 * hpMultipler(),
        size = 12,
        hb = {
            type = RECTANGLE,
            width = 30,
            height = 30
        }
    }
    local enemy = Enemy.new(CAT_BOX, vec(x, y), move, onDeath, nil, nil, config)

    local flyingConfig = newAnimSetting(4, { width = 32, height = 32 }, 0.1, true, 1)
    enemy:addAnimations(flyingConfig)
    return enemy
end
