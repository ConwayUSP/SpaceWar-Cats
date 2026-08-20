
----------------------------------------
-- Estado do Upgrades
----------------------------------------

local DeathScreen = {}
DeathScreen.__index = DeathScreen

DeathScreen.timer = 0

function DeathScreen:load()
	self.timer = 0
  soundManager:play("evil_laugh")
	soundManager:pause("ambience")
end

function DeathScreen:update(dt)
  Physics:update(dt)
	planet:update(dt)
--   enemyManager:update(dt)
--   particleManager:update(dt)

	self.timer = self.timer + dt
end


function DeathScreen:draw()
	love.graphics.setColor(1, 1, 1, 1)
	planet:draw()
  enemyManager:draw()
  p1:draw()
  particleManager:draw()

	love.graphics.setColor(0.08, 0.05, 0.14, 0.8)
	love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
	love.graphics.setColor(1, 1, 1, 1)
end

function DeathScreen:keypressed(key, scancode, isrepeat)
	if self.timer < 1 then
		return
	end

	if key == "space" then
		resetGame()
		runStats:set(RST, love.timer.getTime())
	end

end

function DeathScreen:mousepressed( x, y, button, istouch, presses )
	if self.timer < 1 then
		return
	end

	resetGame()
end

return DeathScreen