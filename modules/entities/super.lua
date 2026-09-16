----------------------------------------
-- Habilidade especial reutilizável
----------------------------------------

Super = {}
Super.__index = Super
Super.type = "Super"

function Super.new(owner, config)
  local self = setmetatable({}, Super)

  self.owner = owner
  self.config = config or {}
  self.name = self.config.name or "Super"
  self.cooldown = self.config.cooldown or 1
  self.duration = self.config.duration
  self.onActivate = self.config.onActivate
  self.onUpdate = self.config.onUpdate
  self.onEnd = self.config.onEnd

  self:reset()
  return self
end

function Super:reset()
  if self.isActive and self.onEnd then
    self.onEnd(self)
  end

  self.cooldownTimer = math.huge
  self.activeTimer = 0
  self.isActive = false
end

function Super:isCooldownReady()
  return self.cooldownTimer >= self.cooldown
end

function Super:getCooldownPercent()
  return math.min(1, self.cooldownTimer / self.cooldown)
end

-- tenta ativar o super
function Super:tryActivate()
  -- se a habilidade ainda está ativa ou está em cooldown, retorna
  if self.isActive or not self:isCooldownReady() then
    return false
  end

  self.cooldownTimer = 0
  self.activeTimer = 0
  self.isActive = self.duration ~= nil and self.duration > 0
  return true
end

function Super:update(dt)
  self.cooldownTimer = self.cooldownTimer + dt

  if not self.isActive then
    return
  end

  self.activeTimer = self.activeTimer + dt
  if self.onUpdate then
    self.onUpdate(self, dt)
  end

  if self.activeTimer >= self.duration then
    self.isActive = false
    if self.onEnd then
      self.onEnd(self)
    end
  end
end
