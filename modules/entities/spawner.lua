----------------------------------------
-- Classe Spawner
----------------------------------------

Spawner = {}
Spawner.__index = Spawner
Spawner.type = "Spawner"


function Spawner.new(enemyFunc, interval, startDelay)
    local spawner = setmetatable({}, Spawner)

    spawner.enemyFunc = enemyFunc
    spawner.intervalInit = interval
    spawner.interval = interval
    spawner.timer = - (startDelay) + interval

    return spawner
end

function Spawner:update(dt)
    self.timer = self.timer + dt
    if self.timer >= self.interval then
        self.enemyFunc()
        self.interval = self.intervalInit + math.random(-0.85 * self.interval, 0.85 * self.interval)
        self.timer = 0
    end
end
