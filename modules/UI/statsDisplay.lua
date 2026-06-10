----------------------------------------
-- Classe StatsDisplay
----------------------------------------

StatsDisplay = {}
StatsDisplay.__index = StatsDisplay

function StatsDisplay.new(stats, pos, width, rowHeight)
  local self = setmetatable({}, StatsDisplay)

  self.stats = stats
  self.pos = pos
  self.width = width or 300
  self.rowHeight = rowHeight or 18

  self.topLeft = vec(pos.x - self.width / 2, pos.y - self.rowHeight)
  self.bottomRight = vec(pos.x + self.width / 2, pos.y + self.rowHeight)

  self.labels = {
    [TDD] = "Damage Dealt",
    [TDT] = "Damage Taken",
    [TEK] = "Enemies Killed",
    [TUP] = "Upgrades Bought",
    [TWS] = "Waves Survived",
    [TRT] = "Run Time"
  }

  self.order = {
    TDD,
    TDT,
    TEK,
    TUP,
    TWS,
    TRT
  }

  self:buildRows()

  return self
end

function StatsDisplay:update(dt)
  for _, row in ipairs(self.rows) do
    row.value.content = self:formatValue(
      row.stat,
      self.stats[row.stat]
    )

    row.label:update(dt)
    row.value:update(dt)
  end
end

function StatsDisplay:draw()
  for i, row in ipairs(self.rows) do
    local startX = self.topLeft.x + row.label.font:getWidth(row.label.content) + 5
    local endX = self.bottomRight.x - row.value.font:getWidth(row.value.content) - 5
    local rowHeight = row.label.font:getHeight()
    local rowY = self.topLeft.y + (i - 1) * self.rowHeight + rowHeight/2

    renderDots(startX, rowY, endX, rowY, 3)
    row.label:draw()
    row.value:draw()
  end
end

function StatsDisplay:formatValue(stat, value)
  if stat == TRT then
    local minutes = math.floor(value / 60)
    local seconds = value % 60
    return string.format("%02d:%02d", minutes, seconds)
  end

  return tostring(value)
end

function StatsDisplay:buildRows()
  self.rows = {}

  local x = self.topLeft.x
  local y = self.topLeft.y

  for i, stat in ipairs(self.order) do
    local rowY = y + (i - 1) * self.rowHeight

    local label = Text.new(
      self.labels[stat],
      10,
      {1,1,1,1},
      vec(x, rowY),
      0,
      false,
      nil,
      nil,
      300,
      "left"
    )

    local value = Text.new(
      self:formatValue(stat, self.stats[stat]),
      8,
      {1,1,1,1},
      vec(x, rowY),
      0,
      false,
      nil,
      nil,
      300,
      "right"
    )

    table.insert(self.rows, {
      label = label,
      value = value,
      stat = stat
    })
  end
end