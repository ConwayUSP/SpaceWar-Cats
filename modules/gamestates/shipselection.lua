----------------------------------------
-- Importacoes de modulos
----------------------------------------
require("modules.utils.cursors")

----------------------------------------
-- Estado de selecao de nave
----------------------------------------

local ShipSelectionState = {}
ShipSelectionState.__index = ShipSelectionState

function ShipSelectionState:getSelectionUI()
	local scene = UIManager.scenes[CTX.SHIP_SELECTION]
	return scene and scene.selection
end

function ShipSelectionState:load()
	soundManager:play("ambience", false, true)
	soundManager:pause("battle")
	love.mouse.setCursor(cursors.arrow)
end

function ShipSelectionState:update(dt)
end

function ShipSelectionState:draw()
end

function ShipSelectionState:keypressed(key, scancode, isrepeat)
	if isrepeat then
		return
	end

	if key == "escape" then
		SetGameCtx(CTX.MENU)
		return
	end

	local selection = self:getSelectionUI()
	if not selection then
		return
	end

	if key == "left" or key == "a" then
		selection:previous()
	elseif key == "right" or key == "d" then
		selection:next()
	elseif key == "return" or key == "space" then
		selection:confirm()
	end
end

return ShipSelectionState
