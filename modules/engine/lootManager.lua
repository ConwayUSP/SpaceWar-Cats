require("modules.utils.types")

LootManager = {}
LootManager.list = {}
LootManager.counters = {[BASIC] = 0}
LootManager.type = "LootManager"

function LootManager:getCounter(lootName)
    return self.counters[lootName]
end

function LootManager:add(loot)
    table.insert(self.list, loot)
    self.counters[loot.name] = (self.counters[loot.name]) + 1
end

function LootManager:update(dt)
    for i = #self.list, 1, -1 do
        local l = self.list[i]
        l:update(dt)
        if not l.active then
            table.remove(self.list, i)
            self.counters[l.name] = self.counters[l.name] - 1
        end
    end
end

function LootManager:reset()
    for i = #self.list, 1, -1 do
        local l = self.list[i]
        l:destroy()
        table.remove(self.list, i)
    end

    self.list = {}
end

function LootManager:draw()
    for _, loot in ipairs(self.list) do
        local alpha = loot.alpha
        love.graphics.setColor(1, 1, 1, alpha)
        loot:draw()
        love.graphics.setColor(1, 1, 1, 1)
    end
end

return LootManager