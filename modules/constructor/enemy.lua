require("modules.utils.utils")
local Enemy = require("modules.entities.enemy")
local enemyManager = require("modules.engine.enemyManager")
local projectiles = require("modules.constructor.projectile")

local enemies = {}

----------------------------------------
-- INIMIGO 1
----------------------------------------
local function moveBasic(self, dt)
    self.timer = (self.timer or 0) + dt
    self.pos.y = self.pos.y + 20 * math.sin(self.timer * 5)
end

local function shootBasic(self)
    local origin = vec(self.pos.x, self.pos.y)
    local weapon = projectiles.proj1
    weapon:shot(origin, weapon.trajectory)
end

local function drawBasic(self)
    love.graphics.setColor(1, 0, 0) -- Vermelho
    love.graphics.circle("fill", self.pos.x, self.pos.y, 20)
end

function enemies.spawnBasic(x, y)
    local enemy = Enemy.new(100, vec(x, y), moveBasic, drawBasic, shootBasic, 2)
    enemyManager.add(enemy)
    return enemy
end

----------------------------------------
-- INIMIGO 2
----------------------------------------
local function moveFast(self, dt)
    self.timer = (self.timer or 0) + dt
    self.pos.y = self.pos.y + 25 * math.cos(self.timer * 5)
end

local function drawFast(self)
    love.graphics.setColor(1, 0.5, 0) -- Laranja
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, 30, 20)
end
local function shootFast(self)
    local origin = vec(self.pos.x, self.pos.y)
    local weapon = projectiles.proj2
    weapon:shot(origin, weapon.trajectory)
end
function enemies.spawnFast(x, y)
    local enemy = Enemy.new(50, vec(x, y), moveFast, drawFast, shootFast, 5)
    enemyManager.add(enemy)
    return enemy
end
return enemies
