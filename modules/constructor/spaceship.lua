local function fireWeaponSpread(player, shots, arc)
  local x, y = player.body:getPosition()
  local origin = addVec(vec(x, y), polarToVec(player.angle, 25))
  local weapon = player.spaceship.weapon

  for i = 0, shots - 1 do
    local offset = shots == 1 and 0 or (-arc / 2 + arc * i / (shots - 1))
    weapon:shoot(player, origin, player.angle + offset)
  end
end

function defaultSpaceship(player)
  local config = {
    name = "Default",

    -- Player / nave
    size = 5,
    scale = 1,
    maxHp = 1,
    speed = 2,

    hb = {
      type = RECTANGLE,
      width = 10,
      height = 5
    },

    -- Arte
    animation = {
      folder = "assets/animations/player",
      state = FLYING,
      frameWidth = 32,
      frameHeight = 32,
      frameDuration = 0.1,
      frames = 4,
      loop = true,
      scale = 1
    },

    -- Arma
    weapon = {
      name = "blaster-tune",
      bulletSpeed = 600,
      firerate = 3,
      scale = 1,
      damage = 40,
      criticalChance = 0.10,
      criticalMultiplier = 1.5,
    },

    -- TODO: trocar para super de verdade
    super = {
      name = "Scatter Blaster",
      cooldown = 7,
      onActivate = function(super)
        fireWeaponSpread(super.owner, 5, math.rad(40))
      end
    }
  }

  return Spaceship.new(config, player)
end

function bomberSpaceship(player)
  local config = {
    name = "Bomber",

    -- Player / nave
    size = 5,
    scale = 1,
    maxHp = 1,
    speed = 2,

    hb = {
      type = RECTANGLE,
      width = 10,
      height = 5
    },

    -- Arte
    animation = {
      folder = "assets/animations/player",
      state = FLYING,
      frameWidth = 32,
      frameHeight = 32,
      frameDuration = 0.1,
      frames = 4,
      loop = true,
      scale = 1
    },

    -- Arma
    weapon = {
      name = "bomb",
      scale = 1,
      firerate = 0.5,
      bulletSpeed = 400,
      damage = 100,
      criticalChance = 0.10,
      criticalMultiplier = 1.5,
    },

    -- TODO: trocar para super de verdade
    super = {
      name = "Bombing Run",
      cooldown = 12,
      onActivate = function(super)
        fireWeaponSpread(super.owner, 3, math.rad(24))
      end
    },

    customHit = function(projectile, target)
      projectile:spawnExplosion(target)
    end
  }

  return Spaceship.new(config, player)
end

function plasmaSpaceship(player)
  local config = {
    name = "Plasmatic",

    -- Player / nave
    size = 5,
    scale = 1,
    maxHp = 1,
    speed = 2,

    hb = {
      type = RECTANGLE,
      width = 10,
      height = 5
    },

    -- Arte
    animation = {
      folder = "assets/animations/player",
      state = FLYING,
      frameWidth = 32,
      frameHeight = 32,
      frameDuration = 0.1,
      frames = 4,
      loop = true,
      scale = 1
    },

    -- Arma
    weapon = {
      name = "plasma",
      scale = 1,
      firerate = 0.4,
      bulletSpeed = 300,
      damage = 100,
      criticalChance = 0.10,
      criticalMultiplier = 1.5,
      charge = {
        time = 2
      }
    },

    -- TODO: trocar para super de verdade
    super = {
      name = "Overcharge",
      cooldown = 15,
      duration = 5,
      onActivate = function(super)
        super.owner.spaceship.weapon.superDamageMultiplier = 2
      end,
      onEnd = function(super)
        super.owner.spaceship.weapon.superDamageMultiplier = 1
      end
    },
  }

  return Spaceship.new(config, player)
end
