----------------------------------------
-- Explosion Manager
----------------------------------------

ExplosionManager = {}
ExplosionManager.list = {}
ExplosionManager.type = "ExplosionManager"

----------------------------------------
-- Add
----------------------------------------

function ExplosionManager:add(explosion)
  table.insert(self.list, explosion)
end

----------------------------------------
-- Update
----------------------------------------

function ExplosionManager:update(dt)
  for i = #self.list, 1, -1 do
    local explosion = self.list[i]
    explosion:update(dt)

    if not explosion.active then
      explosion:destroy()
      table.remove(self.list, i)
    end
  end

end

----------------------------------------
-- Reset
----------------------------------------

function ExplosionManager:reset()

  for i = #self.list, 1, -1 do
    local explosion = self.list[i]
    explosion:destroy()
    table.remove(self.list, i)
  end

  self.list = {}

end

----------------------------------------
-- Draw
----------------------------------------

function ExplosionManager:draw()
  for _, explosion in ipairs(self.list) do
    explosion:draw()
  end
end


return ExplosionManager