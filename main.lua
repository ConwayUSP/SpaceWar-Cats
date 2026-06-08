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
require("modules.engine.uiManager")
require("modules.utils.screen")


VIRTUAL_WIDTH = 640
VIRTUAL_HEIGHT = 360
VIRTUAL_SCALE = 1

SCREEN_WIDTH = VIRTUAL_WIDTH
SCREEN_HEIGHT = VIRTUAL_HEIGHT
SCREEN_SCALE = 1
SCREEN_OFFSET_X = 0
SCREEN_OFFSET_Y = 0

GameCtx = CTX.MENU
world = Physics
debugMode = false
isFullscreen = false

p1 = require("modules.entities.player")
planet = require("modules.entities.planet")
enemyManager = require("modules.engine.enemyManager")
waveManager = require("modules.engine.waveManager")
particleManager = require("modules.engine.particleManager")
shaderManager = require("modules.engine.shaderManager")
soundManager = require("modules.engine.soundManager")

pProjectiles = ProjectileManager.new(CATEGORY.PLAYER_BULLET)
eProjectiles = ProjectileManager.new(CATEGORY.ENEMY_BULLET)

-- Função auxiliar para trocar de contexto e carregar o novo estado
function SetGameCtx(newCtx)
	local sounds = GAMESTATE[GameCtx].sounds
	if sounds then
		for _, sound in pairs(sounds) do
			sound:stop()
		end
	end

  GameCtx = newCtx
  GAMESTATE[GameCtx]:load()
	UIManager:changeScene(GameCtx)
end

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")

	shaderManager:load({
    "scanlines",
    "crt"
	})

	UIManager:load({
		[CTX.BATTLE] = newBattleScene(),
	})

	particleManager:load()

	updateScreenTransform()
	GAMESTATE[GameCtx]:load()
end

function love.resize(width, height)
	updateScreenTransform()
	shaderManager:resize(width, height)
end

function love.update(dt)
	shaderManager:update(dt)

	GAMESTATE[GameCtx]:update(dt)
	UIManager:update(dt)
end

function love.draw()
	shaderManager:begin()

	love.graphics.push()

	love.graphics.translate(
			SCREEN_OFFSET_X,
			SCREEN_OFFSET_Y
	)

	love.graphics.scale(
			SCREEN_SCALE,
			SCREEN_SCALE
	)

	GAMESTATE[GameCtx]:draw()
	UIManager:draw()

	love.graphics.pop()

	shaderManager:finish()
	shaderManager:draw()
end

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.event.quit()
	end

	if key == "f" then 
		isFullscreen = not isFullscreen
		love.window.setFullscreen(isFullscreen)
	end

	if key == "0" then
		debugMode = not debugMode
	end

	if key == "u" then
		SetGameCtx(CTX.UPGRADES)
	end

	if key == "9" then
		shaderManager:toggle()
	end

	if GAMESTATE[GameCtx].keypressed then
		GAMESTATE[GameCtx]:keypressed(key, scancode, isrepeat)
	end
end

function love.mousepressed( x, y, button, istouch, presses )
	if GAMESTATE[GameCtx].mousepressed then
		GAMESTATE[GameCtx]:mousepressed(x, y, button, istouch, presses)
	end
end
