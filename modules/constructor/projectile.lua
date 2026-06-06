----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.entities.projectile")
require("modules.system.movements")

local defaultConfig = {
    speed = 20000,
    damage = 10,
    size = 5
}

----------------------------------------
-- PROJÉTIL 1 
----------------------------------------
function newProj1(projManager, config)
   config = config or defaultConfig
   local proj = Projectile.new("project1", moveLeft, nil, projManager, config)
   return proj
end

----------------------------------------
-- PROJÉTIL 2 
----------------------------------------
function newProj2(projManager, config)
    config = config or defaultConfig
    local proj = Projectile.new("project2", moveLeft, nil, projManager, config)
    return proj
end