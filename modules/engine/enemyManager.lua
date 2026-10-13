require("modules.utils.types")

EnemyManager = {}
EnemyManager.list = {}
EnemyManager.counters = {[CAT_SWIMMER] = 0, [SHOOTER_ENEMY] = 0, [TANK_ENEMY] = 0, [CAT_MAGE] = 0, [CAT_BOX] = 0, [PUFFER_CAT] = 0}
EnemyManager.pendingDeathCallbacks = 0
EnemyManager.type = "EnemyManager"

function EnemyManager:getCounter(enemyName)
    return self.counters[enemyName]
end

function EnemyManager:add(enemy)
    table.insert(self.list, enemy)
    self.counters[enemy.name] = (self.counters[enemy.name]) + 1
end

function EnemyManager:beginDeathCallback()
    self.pendingDeathCallbacks = self.pendingDeathCallbacks + 1
end

function EnemyManager:endDeathCallback()
    self.pendingDeathCallbacks = math.max(0, self.pendingDeathCallbacks - 1)
end

function EnemyManager:isCleared()
    return #self.list == 0 and self.pendingDeathCallbacks == 0
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

function EnemyManager:clearRunState()
    for i = #self.list, 1, -1 do
        local e = self.list[i]
        e:destroy()
        table.remove(self.list, i)
    end

    self.list = {}
    self.pendingDeathCallbacks = 0
    for enemyName in pairs(self.counters) do
        self.counters[enemyName] = 0
    end
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
