----------------------------------------
-- Importações de Módulos
----------------------------------------
math.randomseed(os.time()) -- precisa ficar aqui no topo pra randomizar os oponentes

require("modules.gamectx")
require("modules.gamestate")


GameCtx = CTX.MENU
world = World
debugMode = true

p1 = require("modules.entities.player")
enemies = require("modules.constructor.enemy")
enemyManager = require("modules.engine.enemyManager")
projectiles = require("modules.constructor.projectile")


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
	-- carrega o estado inicial manualmente para usar uma transição
	GAMESTATE[GameCtx]:load()
	enemies.spawnBasic(1800, 50)
	enemies.spawnFast(1800, 80)

end

function love.update(dt)
	GAMESTATE[GameCtx]:update(dt)
	enemyManager.update(dt)
	projectiles.proj1:update(dt)
	projectiles.proj2:update(dt)
end

function love.draw()
	GAMESTATE[GameCtx]:draw()
	enemyManager.draw()
	projectiles.proj1:draw()
	projectiles.proj2:draw()

end

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.event.quit()
	end

	GAMESTATE[GameCtx]:keypressed(key, scancode, isrepeat)
end
