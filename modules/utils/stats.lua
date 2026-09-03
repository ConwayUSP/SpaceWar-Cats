----------------------------------------
-- StatBlock
----------------------------------------

local StatBlock = {}
StatBlock.__index = StatBlock

function StatBlock.new(base)
  local self = setmetatable({}, StatBlock)

  self.base = base or {}
  self.modifiers = {} -- lista de { key = ..., mode = ADD|MULT|SET, value = ... }
  self.current = {}

  self:recalculate()

  return self
end

function StatBlock:recalculate()
  local current = {}

  for key, value in pairs(self.base) do
    current[key] = value
  end

  for _, mod in ipairs(self.modifiers) do
    local value = current[mod.key]

    if value ~= nil then
      if mod.mode == ADD then
        current[mod.key] = value + mod.value
      elseif mod.mode == MULT then
        current[mod.key] = value * mod.value
      elseif mod.mode == SET then
        current[mod.key] = mod.value
      end
    end
  end

  self.current = current
end

function StatBlock:get(key)
  return self.current[key]
end

-- Valor ORIGINAL (sem upgrades), útil para calcular proporções, ex.:
-- "quanto o scale mudou em relação ao original" para escalar uma hitbox.
function StatBlock:getBase(key)
  return self.base[key]
end

-- mode: ADD (padrão), MULT ou SET
function StatBlock:upgrade(key, value, mode)
  mode = mode or ADD

  table.insert(self.modifiers, { key = key, value = value, mode = mode })
  self:recalculate()
end

-- Remove todos os upgrades aplicados, volta para os valores base.
function StatBlock:reset()
  self.modifiers = {}
  self:recalculate()
end

return StatBlock