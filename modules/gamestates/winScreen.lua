
----------------------------------------
-- Estado do Upgrades
----------------------------------------

local WinScreen = {}
WinScreen.__index = WinScreen

WinScreen.timer = 0

function WinScreen:load()
	self.timer = 0
  soundManager:play("win")
	soundManager:pause("ambience")
end

function WinScreen:update(dt)
  Physics:update(dt)
	planet:update(dt)
  enemyManager:update(dt)
  particleManager:update(dt)

	self.timer = self.timer + dt
end


function WinScreen:draw()
	love.graphics.setColor(1, 1, 1, 1)
	planet:draw()
  enemyManager:draw()
  p1:draw()
  particleManager:draw()

	love.graphics.setColor(0.08, 0.05, 0.14, 0.8)
	love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
	love.graphics.setColor(1, 1, 1, 1)
end

function WinScreen:keypressed(key, scancode, isrepeat)
	if self.timer < 1 then
		return
	end

	resetGame()
end

function WinScreen:mousepressed( x, y, button, istouch, presses )
	if self.timer < 1 then
		return
	end

	resetGame()
end

return WinScreen