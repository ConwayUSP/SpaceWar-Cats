----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.text")
require("modules.utils.utils")
require("modules.engine.physics")
require("modules.UI.button")
require("modules.UI.textButton")

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
		label = "SFX VOLUME",
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
		label = "MUSIC VOLUME",
		get = function()
			return soundManager.musicVolume * 10
		end,
		set = function(nextValue)
			soundManager:setMusicVolume(nextValue)
		end
	},

	{
		type = TOGGLE,
		label = "FULLSCREEN",
		get = function()
			return isFullscreen
		end,
		set = function()
			toggleFullscreen()
		end
	},
	{
		type = TOGGLE,
		label = "SCREEN SHAKE",
		get = function()
			return camera:isShakeEnabled()
		end,
		set = function()
			camera:toggleShake()
		end
	},
	{
		type = TOGGLE,
		label = "CRT SHADER",
		get = function()
			return shaderManager:isEnabled("crt")
		end,
		set = function()
			shaderManager:toggleShader("crt")
		end
	},

	{
		type = TOGGLE,
		label = "SCANLINES",

		get = function()
			return shaderManager:isEnabled("scanlines")
		end,

		set = function()
			shaderManager:toggleShader("scanlines")
		end
	},

	{
		type = TOGGLE,
		label = "PARTICLES",

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
	local rowCenterY = self.contentTop + (index - 0.5) * self.rowHeight

	local label = Text.new(
		option.label,
		13,
		{0.82, 0.82, 0.92, 1},
		vec(x, rowCenterY - 7),
		0,
		false,
		nil,
		nil,
		300,
		"left"
	)

	local value = Text.new(
		self:getRightValue(option),
		12,
		{1, 1, 1, 1},
		vec(self.controlCenterX, rowCenterY),
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
		y = rowCenterY,
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
		local buttonWidth = 58
		local buttonHeight = 22

		row.toggleButton = Button.new(
			0,
			0,
			buttonWidth,
			buttonHeight,
			function()
				self:selectOption(row.index)
				self:setOption(1)
			end
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
	if row.option.type == LIST then
		row.leftButton.x = self.controlCenterX - 42
		row.leftButton.y = row.y

		row.rightButton.x = self.controlCenterX + 42
		row.rightButton.y = row.y

	elseif row.option.type == TOGGLE then
		row.toggleButton.x = self.controlCenterX
		row.toggleButton.y = row.y
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

function PauseState:continueGame()
	soundManager:play("select2")
	SetGameCtx(LastGameCtx)
end

function PauseState:returnToMenu()
	resetGame()
end

----------------------------------------
-- Carregamento
----------------------------------------

function PauseState:load()
	self.px = 22
	self.py = 16

	self.rowHeight = 27
	self.headerHeight = 62
	self.footerHeight = 58

	self.width = 420
	self.height = 326

	self.pos = vec(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2)

	self.topLeft = subVec(self.pos, vec(self.width / 2, self.height / 2))

	self.bottomRight = addVec(self.pos, vec(self.width / 2, self.height / 2))
	self.contentTop = self.topLeft.y + self.headerHeight
	self.controlCenterX = self.bottomRight.x - 62
	self.footerTop = self.contentTop + #self.options * self.rowHeight + 7

	self:createState()

	if #self.rows == 0 then
		self:buildRows()
	end

	if not self.continueButton then
		self.continueButton = TextButton.new(
			self.pos.x - 86,
			self.bottomRight.y - 28,
			152,
			30,
			"CONTINUE",
			function()
				self:continueGame()
			end,
			{
				fillColor = {0.42, 0.42, 0.45, 0.84},
				hoverFillColor = {0.54, 0.54, 0.58, 0.94}
			}
		)

		self.menuButton = TextButton.new(
			self.pos.x + 86,
			self.bottomRight.y - 28,
			152,
			30,
			"MAIN MENU",
			function()
				self:returnToMenu()
			end,
			{
				fillColor = {0.16, 0.16, 0.18, 0.76},
				hoverFillColor = {0.3, 0.3, 0.33, 0.92}
			}
		)
	end

	self.titleFont = self.titleFont or returnFont(23)
	self.sectionFont = self.sectionFont or returnFont(10)
	self.controlFont = self.controlFont or returnFont(12)

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
	self.continueButton:update(dt)
	self.menuButton:update(dt)
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

	if self.continueButton.isHovered or self.menuButton.isHovered then
		hovered = true
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
	love.graphics.setColor(0.025, 0.025, 0.035, 0.62)
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
	-- Sombra curta e painel opaco mantêm o jogo visível sem competir com as opções.
	love.graphics.setColor(0, 0, 0, 0.42)
	love.graphics.rectangle("fill", self.topLeft.x + 5, self.topLeft.y + 6, self.width, self.height)

	love.graphics.setColor(0.09, 0.09, 0.105, 0.78)
	love.graphics.rectangle("fill", self.topLeft.x, self.topLeft.y, self.width, self.height)

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("line", self.topLeft.x, self.topLeft.y, self.width, self.height)

	self:drawCenteredLabel("PAUSED", self.titleFont, self.pos.x, self.topLeft.y + 25, {0.94, 0.94, 0.95, 1})
	self:drawCenteredLabel("SETTINGS", self.sectionFont, self.pos.x, self.topLeft.y + 48, {0.58, 0.58, 0.62, 1})

	for index, row in ipairs(self.rows) do
		self:drawRow(row, index)
	end

	self.continueButton:draw()
	self.menuButton:draw()

	love.graphics.setColor(1, 1, 1, 1)
end

function PauseState:drawRow(row, index)
	-- Destaque da opção selecionada.
	if index == self.selectedOption then
		love.graphics.setColor(0.72, 0.72, 0.76, 0.13)
		love.graphics.rectangle("fill", self.topLeft.x + 9, row.y - self.rowHeight / 2 + 2, self.width - 18, self.rowHeight - 4)
	end

	if index < #self.rows then
		love.graphics.setColor(0.58, 0.58, 0.62, 0.12)
		love.graphics.line(self.topLeft.x + self.px, row.y + self.rowHeight / 2, self.bottomRight.x - self.px, row.y + self.rowHeight / 2)
	end

	row.label.color = index == self.selectedOption and {0.95, 0.95, 0.96, 1} or {0.72, 0.72, 0.75, 1}
	row.label:draw()
	
	if row.option.type == LIST then
		love.graphics.setColor(1, 1, 1, 1)
		row.leftButton:draw()
		row.rightButton:draw()
		row.value.color = {0.92, 0.92, 0.94, 1}
		row.value:draw()
	elseif row.option.type == TOGGLE then
		self:drawToggle(row)
	end
end

function PauseState:drawCenteredLabel(content, font, centerX, centerY, color)
	love.graphics.setFont(font)
	love.graphics.setColor(color[1], color[2], color[3], color[4])
	love.graphics.printf(content, centerX - 120, centerY - font:getHeight() / 2, 240, "center")
end

function PauseState:drawToggle(row)
	local button = row.toggleButton
	local enabled = row.option.get()
	local hovered = button.isHovered

	if enabled then
		love.graphics.setColor(0.39, 0.43, 0.41, hovered and 0.95 or 0.82)
	else
		love.graphics.setColor(0.25, 0.24, 0.27, hovered and 0.95 or 0.82)
	end

	love.graphics.rectangle("fill", button.x - button.width / 2, button.y - button.height / 2, button.width, button.height)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("line", button.x - button.width / 2, button.y - button.height / 2, button.width, button.height)
	self:drawCenteredLabel(enabled and "ON" or "OFF", self.controlFont, button.x, button.y, {1, 1, 1, 1})
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
		self:continueGame()
	end
end

----------------------------------------
-- Input: Mouse / Toque
----------------------------------------

function PauseState:mousepressed(x, y, button, istouch, presses)
	local gameX, gameY = screenToGamePosition(x, y)

	if gameX < self.topLeft.x or gameX > self.bottomRight.x or gameY < self.topLeft.y or gameY > self.bottomRight.y then
		self:continueGame()
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

	self.continueButton:mousepressed(x, y, button)
	self.menuButton:mousepressed(x, y, button)
end

function PauseState:mousereleased(x, y, button, istouch, presses)
	for _, row in ipairs(self.rows) do
		if row.option.type == LIST then
			row.leftButton:mousereleased(x, y, button)
			row.rightButton:mousereleased(x, y, button)
		elseif row.option.type == TOGGLE then
			row.toggleButton:mousereleased(x, y, button)
		end
	end


	self.continueButton:mousereleased(x, y, button)
	self.menuButton:mousereleased(x, y, button)
end

function PauseState:touchpressed(id, x, y, dx, dy, pressure)
	local gameX, gameY = screenToGamePosition(x, y)

	if gameX < self.topLeft.x or gameX > self.bottomRight.x or gameY < self.topLeft.y or gameY > self.bottomRight.y then
		self:continueGame()
		return true
	end

	for _, row in ipairs(self.rows) do
		if row.option.type == LIST then
			if row.leftButton:touchpressed(id, x, y) then
				return true
			end

			if row.rightButton:touchpressed(id, x, y) then
				return true
			end
		elseif row.option.type == TOGGLE and row.toggleButton:touchpressed(id, x, y) then
			return true
		end
	end

	if self.continueButton:touchpressed(id, x, y) then
		return true
	end

	if self.menuButton:touchpressed(id, x, y) then
		return true
	end

	return false
end

function PauseState:touchreleased(id, x, y, dx, dy, pressure)
	for _, row in ipairs(self.rows) do
		if row.option.type == LIST then
			row.leftButton:touchreleased(id)
			row.rightButton:touchreleased(id)
		elseif row.option.type == TOGGLE then
			row.toggleButton:touchreleased(id)
		end
	end


	self.continueButton:touchreleased(id)
	self.menuButton:touchreleased(id)
end

function PauseState:cancelTouches()
	for _, row in ipairs(self.rows) do
		if row.option.type == LIST then
			row.leftButton:cancelTouch()
			row.rightButton:cancelTouch()
		elseif row.option.type == TOGGLE then
			row.toggleButton:cancelTouch()
		end
	end


	if self.continueButton then
		self.continueButton:cancelTouch()
		self.menuButton:cancelTouch()
	end
end

----------------------------------------
-- Retorno
----------------------------------------

return PauseState
