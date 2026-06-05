
local enemyManager = {}
enemyManager.list = {}

function enemyManager.add(enemy)
    table.insert(enemyManager.list, enemy)
end

function enemyManager.update(dt)
    for i = #enemyManager.list, 1, -1 do
        local e = enemyManager.list[i]
        e:move(dt)
        if e.isDead then
            table.remove(enemyManager.list, i)
        end
    end
end

function enemyManager.draw()
    for i = 1, #enemyManager.list do
        local e = enemyManager.list[i]
        
        -- AQUI É A MÁGICA: O gerenciador chama o 'draw' que está lá no Enemy.lua!
        e:draw() 
    end
end

return enemyManager