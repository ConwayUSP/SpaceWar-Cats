----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.text")
require("modules.utils.utils")
require("modules.engine.physics")

----------------------------------------
-- Estado do Pause
----------------------------------------

local PauseState = {}
PauseState.__index = PauseState

PauseState.texts = {}
PauseState.state = {}
PauseState.rows = {}
PauseState.timer = 0
PauseState.selectedOption = 1

PauseState.options = {
	{
		type = LIST,
		currentIdx = 11,
		values = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
		label = "SFX",
		get = function()
			return soundManager.sfxVolume * 10
		end,
		set = function(nextValue)
			soundManager:setSFXVolume(nextValue)
		end
	},
	{
		type = LIST,
		currentIdx = 11,
		values = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
		label = "Music",
		get = function()
			return soundManager.musicVolume * 10
		end,
		set = function(nextValue)
			soundManager:setMusicVolume(nextValue)
		end
	},
	{
		type = TOGGLE,
		label = "Fullscreen",
		get = function()
			return isFullscreen
		end,
		set = function()
			toggleFullscreen()
		end
	},
	-- {
	-- 	type = TOGGLE,
	-- 	label = "VSync",
	-- 	get = function()
	-- 		return love.window.getVSync()
	-- 	end,
	-- 	set = function()
	-- 		love.window.setVSync(not love.window.getVSync())
	-- 	end
	-- },
	{
		type = TOGGLE,
		label = "Shake",
		get = function()
			return camera:isShakeEnabled()
		end,
		set = function()
			camera:toggleShake()
		end
	},
	{
		type = TOGGLE,
		label = "CRT Shader",
		get = function()
			return shaderManager:isEnabled("crt")
		end,
		set = function()
			shaderManager:toggleShader("crt")
		end
	},

	{
		type = TOGGLE,
		label = "Scanlines",
		get = function()
			return shaderManager:isEnabled("scanlines")
		end,
		set = function()
			shaderManager:toggleShader("scanlines")
		end
	},
	{
		type = TOGGLE,
		label = "Particles",
		get = function()
			return particleManager:isActive()
		end,
		set = function()
			particleManager:toggle()
		end
	},
}

function PauseState:buildRows(list)
  self.rows = {}

  local x = self.topLeft.x + self.px
  local y = self.topLeft.y + self.py

  for i, stat in ipairs(list) do
    local rowY = y + (i - 1) * self.rowHeight

    local label = Text.new(
      stat.label,
      16,
      {1,1,1,1},
      vec(x, rowY),
      0,
      false,
      nil,
      nil,
      300,
      "left"
    )

    local value = Text.new(
      self:getRightValue(stat),
      14,
      {1,1,1,1},
      vec(x, rowY),
      0,
      false,
      nil,
      nil,
      self.width - self.px * 2,
      "right"
    )

    table.insert(self.rows, {
      label = label,
      value = value,
      stat = stat
    })
  end
end

function PauseState:getRightValue(stat)
	if stat.type == TOGGLE then
		return stat.get() and "ON" or "OFF"
	elseif stat.type == LIST then
		return tostring(stat.values[stat.currentIdx])
	end
end

function PauseState:selectOption(optionIdx)
	self.selectedOption = optionIdx
	soundManager:play("select1")
end

function PauseState:setOption(delta)
	local option = self.state[self.selectedOption]

	if option.type == TOGGLE then
		option.set()
		self.rows[self.selectedOption].value.content = self:getRightValue(option)
	elseif option.type == LIST then
		local currentIdx = option.currentIdx
		local values = option.values
		local nextIdx = (currentIdx + delta - 1) % #values + 1

		option.currentIdx = nextIdx
		option.set(values[nextIdx])

		self.rows[self.selectedOption].value.content = tostring(values[nextIdx])
	end
	soundManager:play("select2")

end

function PauseState:load()
	self.px = 12
	self.py = 12
	self.rowHeight = 25
	self.width = 400
	self.height = #self.options * self.rowHeight + self.py * 2
	
	self.pos = vec(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2)
	self.topLeft = subVec(self.pos, vec(self.width/2, self.height/2))
	self.bottomRight = addVec(self.pos, vec(self.width/2, self.height/2))

	if #self.state == 0 then
		for _, opt in ipairs(self.options) do
			table.insert(self.state, {
				type = opt.type,
				label = opt.label,
				get = opt.get,
				set = opt.set,
				values = opt.values,
				currentIdx = opt.currentIdx
			})
		end
	end

	if #self.rows == 0 then
		self:buildRows(self.state)
	end

	soundManager:play("ambience", false, true)
	love.mouse.setCursor(cursors.crosshair)
end

function PauseState:update(dt)
	self.timer = self.timer + dt
	for _, row in ipairs(self.rows) do
    row.label:update(dt)
    row.value:update(dt)
  end
end

function PauseState:draw()
	planet:draw()
	p1:draw()
	enemyManager:draw()
	pProjectiles:draw()
	eProjectiles:draw()
	particleManager:draw()

	love.graphics.setColor(0.08, 0.05, 0.14, 0.8)
	love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
	love.graphics.setColor(1, 1, 1, 1)

	self:drawMenu()
end

function PauseState:drawMenu()
	-- Fundo
	love.graphics.setColor(0.15, 0.15, 0.15, 1)
	love.graphics.rectangle("fill", self.topLeft.x, self.topLeft.y, self.width, self.height)

	-- Borda
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("line", self.topLeft.x, self.topLeft.y, self.width, self.height)

	for i, row in ipairs(self.rows) do
    local startX = self.topLeft.x + row.label.font:getWidth(row.label.content) + 5 + self.px
    local endX = self.bottomRight.x - row.value.font:getWidth(row.value.content) - 5 - self.px
    local rowHeight = row.label.font:getHeight()
    local rowY = self.topLeft.y + (i - 1) * self.rowHeight + rowHeight/2 + self.py

		if i == self.selectedOption then
			love.graphics.setColor(1, 1, 1, 0.3)
			love.graphics.rectangle("fill", self.topLeft.x + 2, rowY - rowHeight/2 - 2, self.width - 4, rowHeight + 4)
			love.graphics.setColor(1, 1, 1, 1)
		end

    renderDots(startX, rowY, endX, rowY, 3)
    row.label:draw()
    row.value:draw()
  end
end

function PauseState:keypressed(key, scancode, isrepeat)
	local count = #self.options
	if key == "up" or key == "w" then
		self:selectOption((self.selectedOption - 2) % count + 1)
	end

	if key == "down" or key == "s" then
		self:selectOption(self.selectedOption % count + 1)
	end

	if key == "left" or key == "a" then
		self:setOption(-1)
	end

	if key == "right" or key == "d" then
		self:setOption(1)
	end

	if isrepeat or self.timer < 0.05 then
		return
	end
	
	if key == "p" or key == "escape" then
		SetGameCtx(LastGameCtx)
	end
end

function PauseState:mousepressed( x, y, button, istouch, presses )

end

return PauseState