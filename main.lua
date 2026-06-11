----------------------------------------
-- Importações de Módulos
----------------------------------------
math.randomseed(os.time()) -- precisa ficar aqui no topo pra randomizar os oponentes

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


VIRTUAL_WIDTH = 640
VIRTUAL_HEIGHT = 360
VIRTUAL_SCALE = 1

SCREEN_WIDTH = VIRTUAL_WIDTH
SCREEN_HEIGHT = VIRTUAL_HEIGHT
SCREEN_SCALE = 1
SCREEN_OFFSET_X = 0
SCREEN_OFFSET_Y = 0

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
runStats = require("modules.system.runStats")

pProjectiles = ProjectileManager.new(CATEGORY.PLAYER_BULLET)
eProjectiles = ProjectileManager.new(CATEGORY.ENEMY_BULLET)

camera = Camera.new()

-- Função auxiliar para trocar de contexto e carregar o novo estado
function SetGameCtx(newCtx)
	LastGameCtx = GameCtx
	GameCtx = newCtx
	GAMESTATE[GameCtx]:load()
	UIManager:changeScene(GameCtx)
end

function resetGame()
	pProjectiles:clear()
	eProjectiles:clear()
	particleManager:reset()

	p1:reset()
	planet:reset()
	enemyManager:reset()
	waveManager:reset()
	runStats:reset()
	soundManager:stopAll()

	SetGameCtx(CTX.BATTLE)
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
end

function love.keypressed(key, scancode, isrepeat)
	if GAMESTATE[GameCtx].keypressed then
		GAMESTATE[GameCtx]:keypressed(key, scancode, isrepeat)
	end

	if key == "f" or key == "f11" then
		toggleFullscreen()
	end

	if not debugMode then
		return
	end
	
	if key == "0" then
		debugMode = not debugMode
	end

	if key == "n" then
		WaveManager:debugSkipWave()
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

function love.mousepressed(x, y, button, istouch, presses)
	if GAMESTATE[GameCtx].mousepressed then
		GAMESTATE[GameCtx]:mousepressed(x, y, button, istouch, presses)
	end
end
