require("modules.utils.utils")
require("modules.system.render")
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
    projectile.size = config.size or 5

    projectile.name = name
    projectile.trajectory = trajectory -- função que define a trajetória do projétil
    projectile.customHit = customHit           -- função executada toda vez que um projétil acertar um alvo
    projectile.projManager = projManager
    projectile.category = projManager.category
    projectile.projManager:add(projectile)
    projectile.image = love.graphics.newImage(pngPathFormat({ "assets", "sprites", "projectiles", projectile.name }))
    projectile.image:setFilter("nearest", "nearest")

    projectile.events = {}
    return projectile
end

function Projectile:shot(attacker, origin, dir)
    local shotEvent = ShotEvent.new(self, attacker, origin, dir)
    table.insert(self.events, shotEvent)
end

function Projectile:destroy()
    for _, shotEvent in pairs(self.events) do
        shotEvent:destroy()
    end
    self.projManager:remove(self)
end

function Projectile:update(dt)
    for i = #self.events, 1, -1 do
        local shot = self.events[i]
        
        if not shot.active then
            table.remove(self.events, i)
        else
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
            love.graphics.draw(self.image, x, y, 0, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
            debugRender(shot)
        end
    end
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
    shot.speed = projectileState.speed
    shot.dmg = projectileState.dmg
    shot.customHit = projectileState.customHit
    shot.category = projectileState.category
    shot.active = true

    shot.body = love.physics.newBody(Physics.world, shot.initialPos.x, shot.initialPos.y, "dynamic")
    shot.shape = love.physics.newCircleShape(projectileState.size)
    shot.fixture = love.physics.newFixture(shot.body, shot.shape)
    shot.fixture:setUserData(shot)

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
    if self.customHit then
        self:customHit(target)
    end

    target:takeDamage(self.dmg)
    self:destroy()
end

function ShotEvent:destroy(i)
    i = i or tableIndexOf(self.projectileState.events, self)

    self.body:destroy()
    self.active = false
end