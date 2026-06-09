require("modules.constructor.wave")

WaveManager = {}

WaveManager.list = {
    initWave1(),
    initWave2(),
    initWave3(),
    initWave4(),
    initWave5(),
    initWave6(),
    initWave7()

}
WaveManager.currentWaveIndex = 1
WaveManager.type = "WaveManager"
WaveManager.transitionTimer = 0.5
WaveManager.isTransitioning = true

function WaveManager:debugSkipWave()
    GAMESTATE[CTX.BATTLE]:startTransition()
    self.isTransitioning = true
    self.transitionTimer = 0.5
    self.currentWaveIndex = self.currentWaveIndex + 1
    for i = #EnemyManager.list, 1, -1 do
        local e = EnemyManager.list[i]
        e:die()
    end
end

function WaveManager:update(dt)
    if self.currentWaveIndex > #self.list then
        return
    end
    if self.isTransitioning then
        self.transitionTimer = self.transitionTimer - dt
        if self.transitionTimer <= 0 then
            self.isTransitioning = false
            -- Inicia a wave atual
            print("Starting " .. self.list[self.currentWaveIndex].name)
            self.list[self.currentWaveIndex]:start()
        end
        return
    end

    local currentWave = self.list[self.currentWaveIndex]
    currentWave:update(dt)
    if currentWave.isFinished and #EnemyManager.list == 0 then
        print("Wave " .. self.currentWaveIndex .. " finished!")
        GAMESTATE[CTX.BATTLE]:startTransition()
        self.isTransitioning = true
        self.transitionTimer = 0.5
        self.currentWaveIndex = self.currentWaveIndex + 1
    end
end

return WaveManager
