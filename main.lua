----------------------------------------
-- Importações de Módulos
----------------------------------------
math.randomseed(os.time()) -- precisa ficar aqui no topo pra randomizar os oponentes

require("modules.gamectx")
require("modules.gamestate")

GameCtx = CTX.MENU

p1 = require("modules.entities.player")

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
end

function love.update(dt)
	GAMESTATE[GameCtx]:update(dt)
end

function love.draw()
	GAMESTATE[GameCtx]:draw()
end

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.event.quit()
	end

	GAMESTATE[GameCtx]:keypressed(key, scancode, isrepeat)
end
