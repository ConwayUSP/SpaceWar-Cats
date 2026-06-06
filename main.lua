----------------------------------------
-- Importações de Módulos
----------------------------------------
math.randomseed(os.time()) -- precisa ficar aqui no topo pra randomizar os oponentes

require("modules.gamectx")
require("modules.gamestate")
require("modules.entities.projectile")
require("modules.engine.physics")
require("modules.engine.projectileManager")
require("modules.engine.uiManager")


VIRTUAL_WIDTH = 640
VIRTUAL_HEIGHT = 360
VIRTUAL_SCALE = 1

SCREEN_WIDTH = VIRTUAL_WIDTH
SCREEN_HEIGHT = VIRTUAL_HEIGHT
SCREEN_SCALE = 1
SCREEN_OFFSET_X = 0
SCREEN_OFFSET_Y = 0


local function updateScreenTransform()
	SCREEN_WIDTH, SCREEN_HEIGHT = love.graphics.getDimensions()
	SCREEN_SCALE = math.min(SCREEN_WIDTH / VIRTUAL_WIDTH, SCREEN_HEIGHT / VIRTUAL_HEIGHT)
	SCREEN_OFFSET_X = (SCREEN_WIDTH - VIRTUAL_WIDTH * SCREEN_SCALE) / 2
	SCREEN_OFFSET_Y = (SCREEN_HEIGHT - VIRTUAL_HEIGHT * SCREEN_SCALE) / 2
end


function screenToGamePosition(x, y)
	return (x - SCREEN_OFFSET_X) / SCREEN_SCALE, (y - SCREEN_OFFSET_Y) / SCREEN_SCALE
end


GameCtx = CTX.MENU
world = Physics
debugMode = true
isFullscreen = false

p1 = require("modules.entities.player")
enemyManager = require("modules.engine.enemyManager")
waveManager = require("modules.engine.waveManager")
pProjectiles = ProjectileManager.new(CATEGORY.PLAYER_BULLET)
eProjectiles = ProjectileManager.new(CATEGORY.ENEMY_BULLET)
planet = require("modules.entities.planet")


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
end

function love.load()
	-- muda o filtro padrão para eliminar o efeito de blur
	love.graphics.setDefaultFilter("nearest", "nearest")

	updateScreenTransform()
	GAMESTATE[GameCtx]:load()
end

function love.resize(width, height)
	updateScreenTransform()
end

function love.update(dt)
	GAMESTATE[GameCtx]:update(dt)
	UIManager:update(dt)
end

function love.draw()
	love.graphics.push()
	love.graphics.translate(SCREEN_OFFSET_X, SCREEN_OFFSET_Y)
	love.graphics.scale(SCREEN_SCALE, SCREEN_SCALE)
	GAMESTATE[GameCtx]:draw()
	UIManager:draw()
	love.graphics.pop()
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

	if GAMESTATE[GameCtx].keypressed then
		GAMESTATE[GameCtx]:keypressed(key, scancode, isrepeat)
	end
end

function love.mousepressed( x, y, button, istouch, presses )
	if GAMESTATE[GameCtx].mousepressed then
		GAMESTATE[GameCtx]:mousepressed(x, y, button, istouch, presses)
	end
end
