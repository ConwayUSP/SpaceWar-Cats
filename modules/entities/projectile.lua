----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.constructor.particles")
require("modules.entities.explosion")
require("modules.system.render")
require("modules.utils.utils")
require("table")

----------------------------------------
-- Classe Projectile
----------------------------------------

Projectile = {}
Projectile.__index = Projectile
Projectile.type = "Projectile"

function Projectile.new(name, trajectory, customHit, projManager, config)
    local projectile = setmetatable({}, Projectile)
    projectile.dmg = config.damage or 10
    projectile.speed = config.speed or 20000

    projectile.hb = config.hb or { type = "circle", radius = 5 }
    projectile.scale = config.scale or 1
    projectile.sound = config.sound
    projectile.criticalChance = config.criticalChance or 0
    projectile.criticalMultiplier = config.criticalMultiplier or 1.5
    projectile.turnSpeed = config.turnSpeed or 0
    projectile.charge = config.charge
    
    projectile.name = name
    projectile.trajectory = trajectory -- função que define a trajetória do projétil
    projectile.customHit = customHit   -- função executada toda vez que um projétil acertar um alvo
    projectile.projManager = projManager
    projectile.category = projManager.category
    projectile.projManager:add(projectile)
    projectile.image = love.graphics.newImage(pngPathFormat({ "assets", "sprites", "projectiles", projectile.name }))
    projectile.image:setFilter("nearest", "nearest")

    projectile.events = {}
    return projectile
end

function Projectile:changeStats(newStats)
    self.dmg = newStats.damage or self.dmg
    self.speed = newStats.speed or self.speed
    self.hb = newStats.hb or self.hb
    self.scale = newStats.scale or self.scale
    self.criticalChance = newStats.criticalChance or self.criticalChance
    self.criticalMultiplier = newStats.criticalMultiplier or self.criticalMultiplier
end

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

function Projectile:destroy()
    for _, shotEvent in pairs(self.events) do
        shotEvent:destroy()
    end
    self.projManager:remove(self)
end

function Projectile:update(dt)
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

function Projectile:draw()
    for i = 1, #self.events do
        local shot = self.events[i]
        if shot.active then
            local x, y = shot.body:getPosition()
            local vx, vy = shot.body:getLinearVelocity()
            local angle = math.atan2(vy, vx)
            love.graphics.draw(self.image, x, y, angle, self.scale, self.scale, self.image:getWidth() / 2, self.image:getHeight() / 2)
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

    -- if self.charge then
    --     multiplier = self.charge.minMultiplier + (self.charge.maxMultiplier - self.charge.minMultiplier) * ratio
    -- end

    self:shoot(attacker, origin, dir)
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
    shot.turnSpeed = projectileState.turnSpeed
    shot.speed = projectileState.speed
    shot.dmg = projectileState.dmg
    shot.criticalMultiplier = projectileState.criticalMultiplier
    shot.criticalChance = projectileState.criticalChance
    shot.customHit = projectileState.customHit
    shot.category = projectileState.category

    shot.active = true
    shot.timer = 0

    shot.body = love.physics.newBody(Physics.world, shot.initialPos.x, shot.initialPos.y, "dynamic")
    shot.shape = getRightHitbox(projectileState.hb)
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

    if target.hp > 0 then
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
