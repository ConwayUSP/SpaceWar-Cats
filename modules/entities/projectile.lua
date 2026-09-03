----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.constructor.particles")
require("modules.entities.explosion")
require("modules.system.render")
require("modules.utils.utils")
require("table")

local StatBlock = require("modules.utils.stats")

----------------------------------------
-- Classe Projectile
----------------------------------------

Projectile = {}
Projectile.__index = Projectile
Projectile.type = "Projectile"

function Projectile.new(name, trajectory, customHit, projManager, config)
    local projectile = setmetatable({}, Projectile)

    projectile.name = name
    projectile.trajectory = trajectory -- função que define a trajetória do projétil
    projectile.customHit = customHit   -- função executada toda vez que um projétil acertar um alvo
    projectile.projManager = projManager
    projectile.category = projManager.category
    projectile.sound = config.sound
    projectile.charge = config.charge
    projectile.hb = config.hb or { type = CIRCLE, radius = 5 }

    -- Propriedades upgradeáveis via projectile:upgrade(key, value, mode)
    projectile.stats = StatBlock.new({
        damage = config.damage or 10,
        bulletSpeed = config.bulletSpeed or config.speed or 600,
        scale = config.scale or 1,
        criticalChance = config.criticalChance or 0,
        criticalMultiplier = config.criticalMultiplier or 1.5,
        turnSpeed = config.turnSpeed or 0,
        firerate = config.firerate or 4,
    })

    projectile.firerateTimer = math.huge
    projectile.isCharging = false
    projectile.chargeTimer = 0

    projectile.projManager:add(projectile)
    projectile.image = love.graphics.newImage(pngPathFormat({ "assets", "sprites", "projectiles", projectile.name }))
    projectile.image:setFilter("nearest", "nearest")

    projectile.events = {}
    return projectile
end

----------------------------------------
-- Upgrades / Reset
----------------------------------------

function Projectile:upgrade(key, value, mode)
    self.stats:upgrade(key, value, mode)
end

function Projectile:reset()
    self.stats:reset()

    self.firerateTimer = math.huge
    self.isCharging = false
    self.chargeTimer = 0
end

----------------------------------------
-- Hitbox
----------------------------------------

function Projectile:getHitbox()
    local baseScale = self.stats:getBase(SCALE) or 1
    local ratio = self.stats:get(SCALE) / baseScale

    if self.hb.type == CIRCLE then
        return { type = CIRCLE, radius = self.hb.radius * ratio }
    elseif self.hb.type == RECTANGLE then
        return { type = RECTANGLE, width = self.hb.width * ratio, height = self.hb.height * ratio }
    end

    return self.hb
end

----------------------------------------
-- Disparo
----------------------------------------

function Projectile:press(attacker, origin, dir)
    if self.charge then
        if not self.isCharging then
            self:beginCharge()
        end
        return false
    end

    self:shoot(attacker, origin, dir)
    return true
end

function Projectile:shoot(attacker, origin, dir)
    local shotEvent = ShotEvent.new(self, attacker, origin, dir)
    soundManager:play(self.sound or "tiro1", true)
    table.insert(self.events, shotEvent)
end

function Projectile:tryShoot(attacker, origin, dir)
    if not self.charge and self.firerateTimer < (1 / self.stats:get("firerate")) then
        return false
    end

    local fired = self:press(attacker, origin, dir)

    if fired then
        self.firerateTimer = 0
    end

    return fired
end

function Projectile:getCooldownPercent()
    return math.min(1, self.firerateTimer / (1 / self.stats:get("firerate")))
end

function Projectile:update(dt)
    self.firerateTimer = self.firerateTimer + dt

    if self.isCharging then
        self.chargeTimer = math.min(self.chargeTimer + dt, self.charge.time)
    end

    for i = #self.events, 1, -1 do
        local shot = self.events[i]

        if not shot.active then
            table.remove(self.events, i)
        else
            shot.timer = shot.timer + dt
            shot:trajectory(dt)
            local x, y = shot.body:getPosition()
            if (x > VIRTUAL_WIDTH + 100) or (x < -100) or (y > VIRTUAL_HEIGHT + 100) or (y < -100) then
                shot:destroy(i)
            end
        end
    end
end

function Projectile:destroy()
    for _, shotEvent in pairs(self.events) do
        shotEvent:destroy()
    end
    self.events = {}
    self.projManager:remove(self)
end

function Projectile:draw()
    for i = 1, #self.events do
        local shot = self.events[i]
        if shot.active then
            local x, y = shot.body:getPosition()
            local vx, vy = shot.body:getLinearVelocity()
            local angle = math.atan2(vy, vx)
            local scale = self.stats:get(SCALE)
            love.graphics.draw(self.image, x, y, angle, scale, scale, self.image:getWidth() / 2, self.image:getHeight() / 2)
            debugRender(shot)
        end
    end
end

---------------------------------------
--- Charge
---------------------------------------

function Projectile:beginCharge()
    if not self.charge or self.isCharging then
        return
    end

    self.isCharging = true
    self.chargeTimer = 0
end

function Projectile:releaseCharge(attacker, origin, dir)
    if not self.isCharging then
        return
    end

    local ratio = self:getChargeRatio()

    self.isCharging = false
    self.chargeTimer = 0

    -- local multiplier = 1
    --
    -- if self.charge then
    --     multiplier = self.charge.minMultiplier + (self.charge.maxMultiplier - self.charge.minMultiplier) * ratio
    -- end

    self:shoot(attacker, origin, dir)
    self.firerateTimer = 0
end

function Projectile:getChargeRatio()
    if not self.charge then
        return 0
    end

    return math.min(self.chargeTimer / self.charge.time, 1)
end

----------------------------------------
-- Classe ShotEvent
----------------------------------------

ShotEvent = {}
ShotEvent.__index = ShotEvent
ShotEvent.type = "ShotEvent"

function ShotEvent.new(projectileState, attacker, origin, dir)
    local shot = setmetatable({}, ShotEvent)

    shot.initialPos = origin
    shot.attacker = attacker
    shot.dir = dir

    shot.projectileState = projectileState
    shot.trajectory = projectileState.trajectory
    shot.turnSpeed = projectileState.stats:get("turnSpeed")
    shot.speed = projectileState.stats:get("bulletSpeed")
    shot.dmg = projectileState.stats:get("damage")
    shot.criticalMultiplier = projectileState.stats:get("criticalMultiplier")
    shot.criticalChance = projectileState.stats:get("criticalChance")
    shot.customHit = projectileState.customHit
    shot.category = projectileState.category

    shot.active = true
    shot.timer = 0

    shot.body = love.physics.newBody(Physics.world, shot.initialPos.x, shot.initialPos.y, "dynamic")
    shot.shape = getRightHitbox(projectileState:getHitbox())
    shot.fixture = love.physics.newFixture(shot.body, shot.shape)
    shot.fixture:setUserData(shot)
    shot.fixture:setRestitution(0)
    local mask = (projectileState.category == CATEGORY.PLAYER_BULLET) and CATEGORY.ENEMY or CATEGORY.PLAYER
    mask = mask + CATEGORY.TEXT
    shot.fixture:setFilterData(
        projectileState.category,
        mask,
        0
    )
    shot.fixture:setSensor(true)

    return shot
end

function ShotEvent:onHit(target)
    if not self.active then
        return 0
    end

    if self.customHit then
        self:customHit(target)
    end

    local dmg, color = self:calculateDamage(self.dmg)
    local hitPos = vec(self.body:getPosition())

    target:takeDamage(dmg, hitPos, color)

    self:destroy()

    if target:getHp() > 0 then
        soundManager:play("hit1", true)
    end

    return dmg
end

function ShotEvent:calculateDamage(dmg)
    local rand = math.random()
    if rand <= self.criticalChance then
        return dmg * self.criticalMultiplier, {0.7, 0.1, 0.07, 1}
    else
        return dmg, nil
    end
end

function ShotEvent:destroy(i)
    if not self.active then
        return
    end

    i = i or tableIndexOf(self.projectileState.events, self)

    local x, y = self.body:getPosition()
    newExplosionParticle(vec(x, y))
    self.body:destroy()
    self.active = false
end


function ShotEvent:spawnExplosion(target)
    local explosion = Explosion.new(vec(target.body:getX(), target.body:getY()), 64, 80, 3)
    explosionManager:add(explosion)
end

----------------------------------------
-- Collision
----------------------------------------

function ShotEvent:onCollision(target)

    if self.category == CATEGORY.PLAYER_BULLET then
        self:onPlayerBulletCollision(target)

    elseif self.category == CATEGORY.ENEMY_BULLET then
        self:onEnemyBulletCollision(target)
    end

end

function ShotEvent:onPlayerBulletCollision(target)

    if target.type == "Enemy" then

        table.insert(Physics.delayedFunctions, function()
            self:onHit(target)
        end)

    elseif target.type == "Text" then

        table.insert(Physics.delayedFunctions, function()
            target:onHit()
            self:destroy()

            local r = math.random(1, 3)
            soundManager:play("morte" .. r, true)
        end)
    end

end

function ShotEvent:onEnemyBulletCollision(target)

    if target.type == "Player" then
        table.insert(Physics.delayedFunctions, function()
            self:onHit(target)
        end)
    end
end