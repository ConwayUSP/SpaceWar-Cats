require("modules.utils.types")

EnemyManager = {}
EnemyManager.list = {}
EnemyManager.counters = {[CAT_SWIMMER] = 0, [SHOOTER_ENEMY] = 0, [TANK_ENEMY] = 0, [CAT_MAGE] = 0}
EnemyManager.type = "EnemyManager"

function EnemyManager:getCounter(enemyName)
    return self.counters[enemyName]
end

function EnemyManager:add(enemy)
    table.insert(self.list, enemy)
    self.counters[enemy.name] = (self.counters[enemy.name]) + 1
end

function EnemyManager:update(dt)
    for i = #self.list, 1, -1 do
        local e = self.list[i]
        e:update(dt)
        if e.isDead then
            table.remove(self.list, i)
            self.counters[e.name] = self.counters[e.name] - 1
        end
    end
end

function EnemyManager:reset()
    for i = #self.list, 1, -1 do
        local e = self.list[i]
        e:destroy()
        table.remove(self.list, i)
    end

    self.list = {}
end

function EnemyManager:draw()
    for _, enemy in ipairs(self.list) do
        local alpha = enemy.alpha
        love.graphics.setColor(1, 1, 1, alpha)
        enemy:draw()
        love.graphics.setColor(1, 1, 1, 1)
    end
end

return EnemyManager