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
UIManager.elements = {}

function UIManager:update(dt)
  for _, element in pairs(self.elements) do
    if element.active then
      element:update(dt)
    end
  end
end

function UIManager:add(element)
  table.insert(self.elements, element)
  element:load()
  element.active = true
end

----------------------------------------
-- Renderização
----------------------------------------

function UIManager:draw()
  love.graphics.setColor(1, 1, 1)

  for _, element in pairs(self.elements) do
    if element.active then
      element:draw()
    end
  end

  love.graphics.setColor(1, 1, 1)
end