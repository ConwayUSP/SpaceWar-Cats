----------------------------------------
-- Classe Spawner
----------------------------------------

Spawner = {}
Spawner.__index = Spawner
Spawner.type = "Spawner"


function Spawner.new(enemyFunc, interval, startDelay, duration)
    local spawner = setmetatable({}, Spawner)

    spawner.enemyFunc = enemyFunc
    spawner.intervalInit = interval
    spawner.interval = interval
    spawner.timer = -(startDelay or 0) + interval
    spawner.duration = duration or 60
    spawner.totalTime = 0

    return spawner
end

function Spawner:update(dt)
    self.timer = self.timer + dt
    self.totalTime = self.totalTime + dt
    if self.timer >= self.interval then
        if self.totalTime < self.duration then
            self.enemyFunc()
        end
        self.interval = self.intervalInit + math.random(-0.9 * self.interval, 0.9 * self.interval)
        self.timer = 0
    end
end
