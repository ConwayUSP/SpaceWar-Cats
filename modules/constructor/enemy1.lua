local Enemy = require("modules.entities.enemy")
local enemyManager = require("modules.engine.enemyManager")

function movement(self, dt)
    self.timer = (self.timer or 0) + dt
    self.pos.y = self.pos.y + 20 * math.sin(self.timer * 5) -- movimento teste
end

function shotPattern(self)

end
function newEnemy1(x, y)
    local enemy = Enemy.new(
        100,                 -- hp
        vec(x, y),           -- spawnPos 
        movement,            -- move 
        shotPattern,         -- shotPattern
        11                   -- shotAtk
    )

    enemyManager.add(enemy)
    return enemy
end

return newEnemy1