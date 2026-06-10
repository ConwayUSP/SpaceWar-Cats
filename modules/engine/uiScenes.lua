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
-- Entidade UIScene
----------------------------------------

UIScene = {}
UIScene.__index = UIScene
UIScene.type = "UIScene"
UIScene.elements = {}
UIScene.scene = nil

function UIScene.new()
  local self = setmetatable({}, UIScene)
  self.elements = {}
  self.texts = {}
  return self
end

function UIScene:update(dt)
  for _, element in pairs(self.elements) do
    if element.active then
      element:update(dt)
    end
  end
  cleanUpTexts(self.texts)
  updateTexts(self.texts, dt)
end

function UIScene:add(element)
  table.insert(self.elements, element)
  element.active = true
end

function UIScene:addText(text)
  table.insert(self.texts, text)
end

----------------------------------------
-- Renderização
----------------------------------------

function UIScene:draw()
  love.graphics.setColor(1, 1, 1)

  for _, element in pairs(self.elements) do
    if element.active then
      element:draw()
    end
  end
  drawTexts(self.texts)

  love.graphics.setColor(1, 1, 1)
end