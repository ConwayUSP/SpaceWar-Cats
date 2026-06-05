----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.entities.projectile")
require("modules.system.movements")

----------------------------------------
-- PROJÉTIL 1 
----------------------------------------
function newProj1(projManager)
   local proj = Projectile.new("project1", 15, moveLeft, nil, 25000, projManager)
   return proj
end

----------------------------------------
-- PROJÉTIL 2 
----------------------------------------
function newProj2(projManager)
    local proj = Projectile.new("project2", 30, moveLeft, nil, 50000, projManager)
    return proj
end