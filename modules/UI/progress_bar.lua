----------------------------------------
-- Barra de progresso da wave
----------------------------------------

WaveProgressBar = {}
WaveProgressBar.__index = WaveProgressBar
WaveProgressBar.type = "WaveProgressBar"

function WaveProgressBar.new(pos, text, height)
    local self = setmetatable({}, WaveProgressBar)
    self.pos = pos
    self.text = text
    self.height = height
    self.progress = 0
    self.indicator = love.graphics.newImage(
        pngPathFormat({ "assets", "sprites", "UI", "progress-bar", "progress_indicator" })
    )
    return self
end

function WaveProgressBar:update()
	local currentWave = waveManager.list[waveManager.currentWaveIndex]
	if not currentWave or waveManager.isTransitioning then
		self.progress = 0
		return
	end

	self.progress = math.min(0.98, currentWave.timer / currentWave.duration)
	if currentWave.isFinished and #enemyManager.list == 0 then
		self.progress = 1
	end
end

function WaveProgressBar:draw()
    local width = self.text:getDimensions()
    local x = self.pos.x - width / 2
    local y = self.pos.y - self.height / 2

    love.graphics.setColor(1, 1, 1, 0.8)
    love.graphics.rectangle("fill", x, y, width * self.progress, self.height)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(
        self.indicator,
        x + width * self.progress,
        self.pos.y,
        0,
        0.8,
        0.8,
        self.indicator:getWidth() / 2,
        self.indicator:getHeight() / 2
    )

    love.graphics.setColor(1, 1, 1, 1)
end
