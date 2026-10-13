require("modules.constructor.wave")

WaveManager = {}

WaveManager.list = {}
WaveManager.upgradesPending = {}
WaveManager.currentWaveIndex = 0
WaveManager.type = "WaveManager"
WaveManager.transitionTimer = 0.5

function WaveManager:load()
    self:prepareNewRun()
end

function WaveManager:buildWaves()
    self.list = {
        initWave1(),
        initWave2(),
        initWave3(),
        initWave4(),
        initWave5(),
        initWave6(),
        initWave7(),
        initWave8(),
        initWave9(),
        initWave10(),
        initWave11(),
        initWave12(),
        initWave13(),
        initWave14(),
        initWave15()
    }
end

function WaveManager:startWave()
    self.isTransitioning = true
    self.transitionTimer = 0.5
    self.currentWaveIndex = self.currentWaveIndex + 1
    self:applyPendingUpgrades()
end

function WaveManager:addPendingUpgrade(upgrade)
    table.insert(self.upgradesPending, upgrade)
end

function WaveManager:applyPendingUpgrades()
    for _, upgrade in ipairs(self.upgradesPending) do
        upgrade.apply({
            player = p1,
            planet = planet,
        })
    end

    self.upgradesPending = {}
end

function WaveManager:prepareNewRun()
    self:buildWaves()
    self.upgradesPending = {}
    self.currentWaveIndex = 0
    self.isTransitioning = true
    self.transitionTimer = 0.5
end

function WaveManager:debugSkipWave()
    GAMESTATE[CTX.BATTLE]:startTransition()
    for i = #EnemyManager.list, 1, -1 do
        local e = EnemyManager.list[i]
        e:kill()
    end
end

function WaveManager:update(dt)
    if self.currentWaveIndex > #self.list then
        SetGameCtx(CTX.WIN_SCREEN)
        return
    end
    if self.isTransitioning then
        self.transitionTimer = self.transitionTimer - dt
        if self.transitionTimer <= 0 then
            self.isTransitioning = false
            self.list[self.currentWaveIndex]:start()
        end
        return
    end

    local currentWave = self.list[self.currentWaveIndex]
    currentWave:update(dt)
    if currentWave.isFinished and EnemyManager:isCleared() then
        -- print("Wave " .. self.currentWaveIndex .. " finished!")
        if self.currentWaveIndex >= #self.list then
            SetGameCtx(CTX.WIN_SCREEN)
            return
        end
        GAMESTATE[CTX.BATTLE]:startTransition()
        self.isTransitioning = true
        self.transitionTimer = 0.5
    end
end

return WaveManager
