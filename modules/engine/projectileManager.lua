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

function ProjectileManager:draw()
  for i = 1, #self.projectiles do
      local p = self.projectiles[i]
      p:draw()
  end
end