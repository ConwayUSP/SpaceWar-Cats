local RunStats = {}
RunStats.__index = RunStats

function RunStats:load()
  self.stats = {
    [TDD] = 0,
    [TDT] = 0,
    [TEK] = 0,
    [TUP] = 0,
    [TWS] = 0,
    [RST] = 0,
    [RET] = 0,
    [TRT] = 0
  }
end

function RunStats:set(stat, value)
  self.stats[stat] = value
end

function RunStats:add(stat, amount)
  if self.stats[stat] then
    self.stats[stat] = (self.stats[stat] or 0) + amount
  end
end

function RunStats:get(stat)
  return self.stats[stat]
end

function RunStats:reset()
  for _, v in pairs(self.stats) do
    v = 0
  end
end

TDD = "totalDamageDealt"
TDT = "totalDamageTaken"
TEK = "totalEnemiesKilled"
TUP = "totalUpgradesPurchased"
TWS = "totalWavesSurvived"
RST = "runStartTime"
RET = "runEndTime"
TRT = "totalRunTime"

return RunStats