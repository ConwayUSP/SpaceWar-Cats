function defaultSpaceship()
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
    }
  }

  return Spaceship.new(config)
end

function bomberSpaceship()
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

    customHit = function(projectile, target)
      projectile:spawnExplosion(target)
    end
  }

  return Spaceship.new(config)
end