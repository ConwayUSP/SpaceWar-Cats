require("modules.constructor.wave")

WaveManager = {}

WaveManager.list = {
    initWave1(),
    initWave2()

}
WaveManager.currentWaveIndex = 1
WaveManager.type = "WaveManager"
WaveManager.transitionTimer = 2

function WaveManager:load()
    self.isTransitioning = true
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
        self.transitionTimer = 2
        self.currentWaveIndex = self.currentWaveIndex + 1
    end
end

return WaveManager
