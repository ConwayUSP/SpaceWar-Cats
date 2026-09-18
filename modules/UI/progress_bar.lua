----------------------------------------
-- Barra de progresso da wave
----------------------------------------

WaveProgressBar = {}
WaveProgressBar.__index = WaveProgressBar
WaveProgressBar.type = "WaveProgressBar"

function WaveProgressBar.new(pos, width, height)
    local self = setmetatable({}, WaveProgressBar)
    self.pos = pos
    self.width = width
    self.height = height
    self.progress = 0
    self.indicator = love.graphics.newImage(pngPathFormat({ "assets", "sprites", "UI", "progress-bar", "progress_indicator" }))
    self.flag = love.graphics.newImage(pngPathFormat({ "assets", "sprites", "UI", "progress-bar", "flag" }))
    return self
end

function WaveProgressBar:update()
	local currentWave = waveManager.list[waveManager.currentWaveIndex]
	if not currentWave then
		self.progress = 0
		return
	end

	self.progress = math.min(1.0, currentWave.timer / currentWave.duration)
	if currentWave.isFinished and #enemyManager.list == 0 then
		self.progress = 1
	end
end

function WaveProgressBar:draw()
    local leftX = self.pos.x - self.width / 2
    local startX = leftX + self.width * (1 - self.progress)
    local y = self.pos.y - self.height / 2

    love.graphics.setColor(1, 1, 1, 0.2)
    love.graphics.rectangle("fill", leftX, y, self.width, self.height)
    love.graphics.setColor(1, 1, 1, 0.8)
    love.graphics.rectangle("fill", startX, y, self.width * self.progress, self.height)

    local scale = 0.8

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.flag, leftX, self.pos.y, 0,scale, scale, self.flag:getWidth() / 2, self.flag:getHeight() / 2)
    love.graphics.draw(self.indicator, startX, self.pos.y, 0,scale, scale, self.indicator:getWidth() / 2, self.indicator:getHeight() / 2)

    love.graphics.setColor(1, 1, 1, 1)
end
