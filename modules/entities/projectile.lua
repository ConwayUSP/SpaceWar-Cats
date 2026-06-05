require("modules.utils.utils")
require("table")

----------------------------------------
-- Classe Projectile
----------------------------------------

local Projectile = {}

Projectile.__index = Projectile

function Projectile.new(dmg, trajectory, ally, onHit, speed, drawSprite)
    local projectile = setmetatable({}, Projectile)
    projectile.ally = ally             -- true se for de um player e false se for de um inimigo
    projectile.dmg = dmg               -- dano base do ataque
    projectile.trajectory = trajectory -- função que define a trajetória do projétil
    projectile.onHit = onHit           -- função executada toda vez que um projétil acertar um alvo
    projectile.speed = speed
    projectile.drawSprite = drawSprite
    projectile.events = {}
    return projectile
end

local ShotEvent = {}
ShotEvent.__index = ShotEvent


function Projectile:shot(origin, trajectory)
    local shotEvent = ShotEvent.new(self, origin, trajectory)
    table.insert(self.events, shotEvent)
end

function ShotEvent.new(projectileState, origin, trajectory)
    local shot = setmetatable({}, ShotEvent)

    shot.pos = origin
    shot.trajectory = trajectory
    shot.ally = projectileState.ally
    shot.speed = projectileState.speed
    shot.dmg = projectileState.dmg
    shot.onHit = projectileState.onHit
    return shot
end

function Projectile:update(dt)
    for i = #self.events, 1, -1 do
        local shot = self.events[i]
        shot.trajectory(shot, dt)
        if (shot.pos.x > love.graphics.getWidth()) or (shot.pos.x < 50) then
            table.remove(self.events, i)
        end
    end
end

function Projectile:draw()
    if self.drawSprite then
        for i = 1, #self.events do
            local shot = self.events[i]
            self.drawSprite(shot)
        end
    end
end

return Projectile
