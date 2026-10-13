----------------------------------------
-- Importações de Módulos
----------------------------------------
math.randomseed(os.time()) -- precisa ficar aqui no topo pra randomizar os oponentes

require("modules.system.globals")
require("modules.gamectx")
require("modules.gamestate")
require("modules.entities.projectile")
require("modules.engine.physics")
require("modules.engine.projectileManager")
require("modules.engine.soundManager")
require("modules.entities.music")
require("modules.entities.sfx")
require("modules.engine.uiManager")
require("modules.utils.screen")
require("modules.system.runStats")
require("modules.engine.camera")

GameCtx = CTX.MENU
LastGameCtx = nil
world = Physics
debugMode = false
isFullscreen = false

bg = require("modules.entities.background")
p1 = require("modules.entities.player")
planet = require("modules.entities.planet")
enemyManager = require("modules.engine.enemyManager")
waveManager = require("modules.engine.waveManager")
particleManager = require("modules.engine.particleManager")
shaderManager = require("modules.engine.shaderManager")
soundManager = require("modules.engine.soundManager")
lootManager = require("modules.engine.lootManager")
explosionManager = require("modules.engine.explosionManager")
runStats = require("modules.system.runStats")

pProjectiles = ProjectileManager.new(CATEGORY.PLAYER_BULLET)
eProjectiles = ProjectileManager.new(CATEGORY.ENEMY_BULLET)

camera = Camera.new()

-- Função auxiliar para trocar de contexto e carregar o novo estado
function SetGameCtx(newCtx)
	UIManager:cancelTouches()
	if p1 and p1.cancelTouches then
		p1:cancelTouches()
	end
	LastGameCtx = GameCtx
	GameCtx = newCtx
	GAMESTATE[GameCtx]:load()
	UIManager:changeScene(GameCtx)
end

function resetGame()
	enemyManager:reset()
	eProjectiles:reset()

	pProjectiles:clear()
	particleManager:reset()

	p1:reset()
	planet:reset()
	waveManager:reset()
	explosionManager:reset()
	runStats:reset()
	soundManager:stopAll()

	SetGameCtx(CTX.MENU)
end

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")

	Physics:load()
	particleManager:load()
	planet:load()
	p1:load()
	waveManager:load()
	runStats:load()
	soundManager:load()
	bg:load()
	shaderManager:load({
		"scanlines",
		"crt"
	})

	UIManager:load({
		[CTX.MENU] = newMenuScene(),
		[CTX.SHIP_SELECTION] = newShipSelectionScene(),
		[CTX.BATTLE] = newBattleScene(),
		[CTX.UPGRADES] = newUpgradeScene(),
		[CTX.DEATH_SCREEN] = newDeathScene(),
		[CTX.WIN_SCREEN] = newWinScene(),
		[CTX.PAUSE] = newPauseScene()
	})


	updateScreenTransform()
	SetGameCtx(CTX.MENU)
end

function love.resize(width, height)
	updateScreenTransform()
	shaderManager:resize(width, height)
end

function love.update(dt)
	shaderManager:update(dt)

	GAMESTATE[GameCtx]:update(dt)
	UIManager:update(dt)
	bg:update(dt)
	camera:update(dt)	
end

function love.draw()
	shaderManager:begin()

	love.graphics.push()

	love.graphics.translate(SCREEN_OFFSET_X, SCREEN_OFFSET_Y)
	love.graphics.scale(SCREEN_SCALE, SCREEN_SCALE)

	camera:attach()
		bg:draw()
		GAMESTATE[GameCtx]:draw()
		UIManager:draw()
	camera:detach()

	love.graphics.pop()

	shaderManager:finish()
	shaderManager:draw()

	-- love.graphics.print(string.format("FPS: %.1f  dt: %.4f", love.timer.getFPS(), love.timer.getDelta()), 10, 10)
end

function love.keypressed(key, scancode, isrepeat)
	if GAMESTATE[GameCtx].keypressed then
		GAMESTATE[GameCtx]:keypressed(key, scancode, isrepeat)
	end

	if key == "f" or key == "f11" then
		toggleFullscreen()
	end

	-- if not debugMode then
	-- 	return
	-- end
	
	if key == "0" then
		debugMode = not debugMode
	end

	if key == "n" then
		WaveManager:debugSkipWave()
	end

	if key == "b" then
		SetGameCtx(CTX.BATTLE)
	end

	if key == "u" then
		SetGameCtx(CTX.UPGRADES)
	end

	if key == "9" then
		shaderManager:toggle()
	end

	if key == "d" then
		planet:takeDamage(100)
	end

	if key == "h" then
		planet:heal(10)
	end

end

function love.keyreleased(key, scancode)
	if GAMESTATE[GameCtx].keyreleased then
		GAMESTATE[GameCtx]:keyreleased(key, scancode)
	end
end

function love.mousepressed(x, y, button, istouch, presses)
	if istouch then
		return
	end

	UIManager:mousepressed(x, y, button, istouch, presses)

	if GAMESTATE[GameCtx].mousepressed then
		GAMESTATE[GameCtx]:mousepressed(x, y, button, istouch, presses)
	end
end

function love.mousereleased(x, y, button, istouch, presses)
	if istouch then
		return
	end

	UIManager:mousereleased(x, y, button, istouch, presses)

	if GAMESTATE[GameCtx].mousereleased then
		GAMESTATE[GameCtx]:mousereleased(x, y, button, istouch, presses)
	end
end

function love.touchpressed(id, x, y, dx, dy, pressure)
	local consumed = UIManager:touchpressed(id, x, y, dx, dy, pressure)
	local state = GAMESTATE[GameCtx]

	if consumed then
		return
	end

	if state.touchpressed then
		state:touchpressed(id, x, y, dx, dy, pressure)
	elseif state.mousepressed then
		state:mousepressed(x, y, 1, true, 1)
	end
end

function love.touchmoved(id, x, y, dx, dy, pressure)
	UIManager:touchmoved(id, x, y, dx, dy, pressure)

	local state = GAMESTATE[GameCtx]
	if state.touchmoved then
		state:touchmoved(id, x, y, dx, dy, pressure)
	end
end

function love.touchreleased(id, x, y, dx, dy, pressure)
	UIManager:touchreleased(id, x, y, dx, dy, pressure)

	local state = GAMESTATE[GameCtx]
	if state.touchreleased then
		state:touchreleased(id, x, y, dx, dy, pressure)
	elseif state.mousereleased then
		state:mousereleased(x, y, 1, true, 1)
	end
end
