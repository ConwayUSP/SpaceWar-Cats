----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.text")
require("modules.utils.utils")
require("modules.engine.physics")
require("modules.UI.button")

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

----------------------------------------
-- Configuração das Opções
----------------------------------------

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

----------------------------------------
-- Estado das Opções
----------------------------------------

-- Cria uma cópia da configuração das opções.
-- O estado é mantido separado para permitir alterações
-- durante a execução do menu.
function PauseState:createState()
	if #self.state > 0 then
		return
	end

	for _, option in ipairs(self.options) do
		table.insert(self.state, {
			type = option.type,
			label = option.label,
			get = option.get,
			set = option.set,
			values = option.values,
			currentIdx = option.currentIdx
		})
	end
end

function PauseState:getOption(index)
	return self.state[index or self.selectedOption]
end

----------------------------------------
-- Valores das Opções
----------------------------------------

function PauseState:getRightValue(option)
	if option.type == TOGGLE then
		return option.get() and "ON" or "OFF"
	end

	if option.type == LIST then
		return tostring(option.values[option.currentIdx])
	end
end

----------------------------------------
-- Criação das Rows
----------------------------------------

-- Cria a representação visual de uma opção.
-- Controles adicionais (botões, setas etc.) podem ser
-- adicionados aqui posteriormente.
function PauseState:createRow(option, index)
	local x = self.topLeft.x + self.px
	local endX = self.bottomRight.x - self.px
	local y = self.topLeft.y + self.py
	local rowY = y + (index - 1) * self.rowHeight

	local label = Text.new(
		option.label,
		16,
		{1, 1, 1, 1},
		vec(x, rowY),
		0,
		false,
		nil,
		nil,
		300,
		"left"
	)

	local value = Text.new(
		self:getRightValue(option),
		14,
		{1, 1, 1, 1},
		vec(endX - 20, rowY + label.font:getHeight() / 2),
		0,
		true,
		nil,
		nil,
		nil,
		"center"
	)

	local row = {
		label = label,
		value = value,
		option = option,
		index = index,

		x = x,
		y = rowY,
	}

	self:createControls(row)

	return row
end

function PauseState:createControls(row)
	if row.option.type == LIST then
		local buttonSize = 32

		row.leftButton = Button.new(
			0,
			0,
			buttonSize,
			buttonSize,
			function()
				self:selectOption(row.index)
				self:decreaseOption()
			end,
			"arrow",
			true
		)

		row.rightButton = Button.new(
			0,
			0,
			buttonSize,
			buttonSize,
			function()
				self:selectOption(row.index)
				self:increaseOption()
			end,
			"arrow"
		)

	elseif row.option.type == TOGGLE then
		local buttonWidth = 48
		local buttonHeight = 32

		row.toggleButton = Button.new(
			0,
			0,
			buttonWidth,
			buttonHeight,
			function()
				self:selectOption(row.index)
				self:setOption(1)
			end,
			"small-button"
		)
	end

	self:updateControls(row)
end

function PauseState:buildRows()
	self.rows = {}

	for index, option in ipairs(self.state) do
		local row = self:createRow(option, index)
		table.insert(self.rows, row)
	end
end

function PauseState:getValueBounds(row)
	local value = row.value

	local textWidth = value.font:getWidth(value.content)
	local textHeight = value.font:getHeight()

	local centerX = value.pos.x
	local centerY = value.pos.y

	local left = centerX - textWidth / 2
	local right = centerX + textWidth / 2
	local top = centerY - textHeight / 2
	local bottom = centerY + textHeight / 2

	return {
		left = left,
		right = right,
		top = top,
		bottom = bottom,

		centerX = centerX,
		centerY = centerY,

		width = textWidth,
		height = textHeight
	}
end

----------------------------------------
-- Atualização das Rows
----------------------------------------

-- Atualiza apenas o conteúdo visual da row.
-- A lógica da opção continua pertencendo à própria opção.
function PauseState:updateRow(row)
	row.value.content = self:getRightValue(row.option)
end

function PauseState:updateRows(dt)
	for _, row in ipairs(self.rows) do
		row.label:update(dt)
		row.value:update(dt)

		if row.option.type == LIST then
			row.leftButton:update(dt)
			row.rightButton:update(dt)
		elseif row.option.type == TOGGLE then
			row.toggleButton:update(dt)
		end
	end
end

function PauseState:updateControls(row)
	local bounds = self:getValueBounds(row)

	local spacing = 15

	if row.option.type == LIST then
		row.leftButton.x = bounds.left - spacing
		row.leftButton.y = bounds.centerY

		row.rightButton.x = bounds.right + spacing
		row.rightButton.y = bounds.centerY

	elseif row.option.type == TOGGLE then
		row.toggleButton.x = bounds.centerX
		row.toggleButton.y = bounds.centerY
	end
end

----------------------------------------
-- Seleção de Opções
----------------------------------------

function PauseState:selectOption(optionIdx)
	self.selectedOption = optionIdx
	soundManager:play("select1")
end

function PauseState:selectPreviousOption()
	local count = #self.state

	self:selectOption((self.selectedOption - 2) % count + 1)
end

function PauseState:selectNextOption()
	local count = #self.state

	self:selectOption(self.selectedOption % count + 1)
end

----------------------------------------
-- Alteração de Opções
----------------------------------------

-- Altera o valor da opção selecionada.
-- Tanto teclado quanto futuros controles de toque devem
-- utilizar esta função para manter uma única fonte de lógica.
function PauseState:setOption(delta)
	local option = self:getOption()
	local row = self.rows[self.selectedOption]

	if option.type == TOGGLE then
		option.set()

	elseif option.type == LIST then
		local currentIdx = option.currentIdx
		local values = option.values

		local nextIdx = (currentIdx + delta - 1) % #values + 1

		option.currentIdx = nextIdx
		option.set(values[nextIdx])
	end

	self:updateRow(row)

	soundManager:play("select2")
end

function PauseState:decreaseOption()
	self:setOption(-1)
end

function PauseState:increaseOption()
	self:setOption(1)
end

----------------------------------------
-- Carregamento
----------------------------------------

function PauseState:load()
	self.px = 12
	self.py = 12

	self.rowHeight = 25

	self.width = 400
	self.height = #self.options * self.rowHeight + self.py * 2

	self.pos = vec(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2)

	self.topLeft = subVec(self.pos, vec(self.width / 2, self.height / 2))

	self.bottomRight = addVec(self.pos, vec(self.width / 2, self.height / 2))

	self:createState()

	if #self.rows == 0 then
		self:buildRows()
	end

	soundManager:play("ambience", false, true)
	soundManager:pause("battle")

	love.mouse.setCursor(cursors.crosshair)
end

----------------------------------------
-- Update
----------------------------------------

function PauseState:update(dt)
	self.timer = self.timer + dt

	self:updateRows(dt)
	self:updateCursor()
end

function PauseState:updateCursor()
	local hovered = false

	for _, row in ipairs(self.rows) do
		if row.leftButton and row.leftButton:isMouseOver() then
			hovered = true
			break
		end

		if row.rightButton and row.rightButton:isMouseOver() then
			hovered = true
			break
		end

		if row.toggleButton and row.toggleButton:isMouseOver() then
			hovered = true
			break
		end
	end

	love.mouse.setCursor(hovered and cursors.hand or cursors.arrow)
end

----------------------------------------
-- Desenho
----------------------------------------

function PauseState:draw()
	planet:draw()
	p1:draw()
	enemyManager:draw()
	pProjectiles:draw()
	eProjectiles:draw()
	particleManager:draw()

	-- Overlay escuro sobre o jogo.
	love.graphics.setColor(0.08, 0.05, 0.14, 0.8)
	love.graphics.rectangle(
		"fill",
		0,
		0,
		VIRTUAL_WIDTH,
		VIRTUAL_HEIGHT
	)

	love.graphics.setColor(1, 1, 1, 1)

	self:drawMenu()
end

function PauseState:drawMenu()
	-- Fundo do menu.
	love.graphics.setColor(0.15, 0.15, 0.15, 1)

	love.graphics.rectangle(
		"fill",
		self.topLeft.x,
		self.topLeft.y,
		self.width,
		self.height
	)

	-- Borda do menu.
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.rectangle(
		"line",
		self.topLeft.x,
		self.topLeft.y,
		self.width,
		self.height
	)

	for index, row in ipairs(self.rows) do
		self:drawRow(row, index)
	end
end

function PauseState:drawRow(row, index)
	local startX =
		self.topLeft.x
		+ row.label.font:getWidth(row.label.content)
		+ 5
		+ self.px

	local endX =
		self.bottomRight.x
		- row.value.font:getWidth(row.value.content)
		- 5
		- self.px
		- (row.option.type == LIST and 32 or 0)

	local rowHeight = row.label.font:getHeight()

	local rowY =
		self.topLeft.y
		+ (index - 1) * self.rowHeight
		+ rowHeight / 2
		+ self.py

	-- Destaque da opção selecionada.
	if index == self.selectedOption then
		love.graphics.setColor(1, 1, 1, 0.3)

		love.graphics.rectangle(
			"fill",
			self.topLeft.x + 2,
			rowY - rowHeight / 2 - 2,
			self.width - 4,
			rowHeight
		)

		love.graphics.setColor(1, 1, 1, 1)
	end

	renderDots(startX, rowY, endX, rowY, 3)

	row.label:draw()
	
	if row.option.type == LIST then
		row.leftButton:draw()
		row.rightButton:draw()
	elseif row.option.type == TOGGLE then
		row.toggleButton:draw()
	end

	row.value:draw()
end

----------------------------------------
-- Input: Teclado
----------------------------------------

function PauseState:keypressed(key, scancode, isrepeat)
	-- Navegação entre as opções.
	if key == "up" or key == "w" then
		self:selectPreviousOption()
	end

	if key == "down" or key == "s" then
		self:selectNextOption()
	end

	-- Alteração do valor da opção.
	if key == "left" or key == "a" then
		self:decreaseOption()
	end

	if key == "right" or key == "d" then
		self:increaseOption()
	end

	-- Evita que o input de pausa seja disparado durante
	-- uma repetição automática do teclado.
	if isrepeat or self.timer < 0.05 then
		return
	end

	if key == "p" or key == "escape" then
		SetGameCtx(LastGameCtx)
	end
end

----------------------------------------
-- Input: Mouse / Toque
----------------------------------------

function PauseState:mousepressed(x, y, button, istouch, presses)
	local gameX, gameY = screenToGamePosition(x, y)

	if gameX < self.topLeft.x or gameX > self.bottomRight.x or gameY < self.topLeft.y or gameY > self.bottomRight.y then
		SetGameCtx(LastGameCtx)
		return
	end

	for index, row in ipairs(self.rows) do
		if row.option.type == LIST then
			row.leftButton:mousepressed(x, y, button)
			row.rightButton:mousepressed(x, y, button)
		elseif row.option.type == TOGGLE then
			row.toggleButton:mousepressed(x, y, button)
		end
	end
end

----------------------------------------
-- Retorno
----------------------------------------

return PauseState