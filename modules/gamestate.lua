----------------------------------------
-- Importação de módulos
----------------------------------------
require("modules.gamectx")

----------------------------------------
-- Tabela de estados do jogo
----------------------------------------

GAMESTATE = {}
GAMESTATE[CTX.MENU] = require("modules.gamestates.menu")
GAMESTATE[CTX.BATTLE] = require("modules.gamestates.battle")
GAMESTATE[CTX.UPGRADES] = require("modules.gamestates.upgrades")
GAMESTATE[CTX.DEATH_SCREEN] = require("modules.gamestates.deathscreen")
GAMESTATE[CTX.PAUSE] = require("modules.gamestates.pause")
