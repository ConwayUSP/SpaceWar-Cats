----------------------------------------
-- Classe Wave (Por Tempo)
----------------------------------------

Wave = {}
Wave.__index = Wave
Wave.type = "Wave"

function Wave.new(name, duration, spawners)
    local wave = setmetatable({}, Wave)

    wave.name = name
    wave.duration = duration
    wave.spawners = spawners
    wave.timer = 0 -- tempo wave

    wave.isRunning = false
    wave.isFinished = false

    return wave
end

function Wave:start()
    self.isRunning = true
    self.timer = 0
    self.spawnTimer = 0
end

function Wave:update(dt)
    -- wave não começou ou terminou, não faz nada
    if not self.isRunning or self.isFinished then return end
    for i = #self.spawners, 1, -1 do
        local e = self.spawners[i]
        e:update(dt)
    end
    self.timer = self.timer + dt
    -- Se o tempo da wave atingiu a duração total, ela para de spawnar
    if self.timer >= self.duration then
        self.isFinished = true
    end
end
