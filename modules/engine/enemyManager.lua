EnemyManager = {}
EnemyManager.list = {}
EnemyManager.type = "EnemyManager"

function EnemyManager:add(enemy)
    table.insert(self.list, enemy)
end

function EnemyManager:update(dt)
    for i = #self.list, 1, -1 do
        local e = self.list[i]
        if e.isDead then
            table.remove(self.list, i)
        else
            e:update(dt)
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