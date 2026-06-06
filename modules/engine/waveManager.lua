require("modules.constructor.wave")

WaveManager = {}

WaveManager.list = {
    addWave1(),
    addWave2()

}
WaveManager.currentWaveIndex = 1
WaveManager.type = "WaveManager"

WaveManager.isTransitioning = true
WaveManager.transitionTimer = 2

function WaveManager:update(dt)
    if self.currentWaveIndex > #self.list then
        return
    end
    if self.isTransitioning then
        self.transitionTimer = self.transitionTimer - dt
        if self.transitionTimer <= 0 then
            self.isTransitioning = false
            -- Inicia a wave atual
            self.list[self.currentWaveIndex]:start()
        end
        return
    end

    local currentWave = self.list[self.currentWaveIndex]
    currentWave:update(dt)

    if currentWave.isFinished and #EnemyManager.list == 0 then
        self.isTransitioning = true
        self.transitionTimer = 2
        self.currentWaveIndex = self.currentWaveIndex + 1
    end
end

return WaveManager
