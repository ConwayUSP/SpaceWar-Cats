local Projectile = require("modules.entities.projectile")
local projectiles = {}

----------------------------------------
-- PROJÉTIL 1 
----------------------------------------
local function moveLeft(shot, dt)
    shot.pos.x = shot.pos.x - (shot.speed * dt)
end

local function hitEffect1(shot)

end

local function drawProj1(shot)
    love.graphics.setColor(1, 1, 0) -- Amarelo
    love.graphics.circle("fill", shot.pos.x, shot.pos.y, 5)
end

projectiles.proj1 = Projectile.new(15, moveLeft, false, hitEffect1, 250, drawProj1)


----------------------------------------
-- PROJÉTIL 2 
----------------------------------------
local function moveLeftFast(shot, dt)
    shot.pos.x = shot.pos.x - (shot.speed * dt)
end

local function hitEffect2(shot)

end

local function drawProj2(shot)
    love.graphics.setColor(0, 0, 1) -- Azul
    love.graphics.rectangle("fill", shot.pos.x, shot.pos.y, 15, 4) 
end

projectiles.proj2 = Projectile.new(30, moveLeftFast, false, hitEffect2, 500, drawProj2)

return projectiles