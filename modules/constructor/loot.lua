----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.utils.utils")
require("modules.entities.loot")
require("modules.utils.types")

----------------------------------------
-- LOOT 1
----------------------------------------

function newBasic(x, y, vx)
    vx = vx or 1
    local function move(self, dt)
        local f = -math.cos(self.timer * math.pi) + 1.2
        -- self.body:setLinearVelocity(-45 * f * vx, 0)
    end
    local function effect()
        planet:heal(50)
    end
    local pos = vec(x, y)
    local config = {}

    local loot = Loot.new(BASIC, move, pos, config, effect)
    local flyingConfig = newAnimSetting(9, { width = 32, height = 32 }, 0.1, true, 1)
    loot:addAnimations(flyingConfig)
    return loot
end
