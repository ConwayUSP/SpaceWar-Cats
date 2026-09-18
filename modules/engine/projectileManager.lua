ProjectileManager = {}
ProjectileManager.__index = ProjectileManager
ProjectileManager.type = "ProjectileManager"

function ProjectileManager.new(category)
  local manager = setmetatable({}, ProjectileManager)
  manager.projectiles = {}
  manager.category = category
  return manager
end

function ProjectileManager:add(projectile)
  table.insert(self.projectiles, projectile)
end

function ProjectileManager:update(dt)
  for i = #self.projectiles, 1, -1 do
      local p = self.projectiles[i]
      p:update(dt)
  end
end

function ProjectileManager:clear()
  for i = #self.projectiles, 1, -1 do
    for _, shotEvent in pairs(self.projectiles[i].events) do
      shotEvent:destroy()
    end
  end
end

function ProjectileManager:reset()
  for i = #self.projectiles, 1, -1 do
    local p = self.projectiles[i]
    p:destroy()
  end

  self.projectiles = {}
end

function ProjectileManager:remove(projectile)
  local idx = tableIndexOf(self.projectiles, projectile)
  if idx then
    table.remove(self.projectiles, idx)
  end
end

function ProjectileManager:draw()
  for _, projectile in ipairs(self.projectiles) do
    projectile:draw()
  end
end