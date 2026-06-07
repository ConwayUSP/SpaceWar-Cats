----------------------------------------
-- Importações de Módulos
----------------------------------------
require("table")
require("modules.engine.animation")
require("modules.utils.vec")
require("modules.engine.physics")
require("modules.engine.projectileManager")
require("modules.system.render")
require("modules.entities.projectile")
require("modules.utils.states")

----------------------------------------
-- Entidade UIManager
----------------------------------------

UIManager = {}
UIManager.__index = UIManager
UIManager.type = "UIManager"
UIManager.scene = nil

function UIManager:update(dt)
  if self.scene then
    self.scene:update(dt)
  end
end

function UIManager:changeScene(newScene)
  self.scene = newScene
end

----------------------------------------
-- Renderização
----------------------------------------

function UIManager:draw()
  if self.scene then
    self.scene:draw()
  end
end