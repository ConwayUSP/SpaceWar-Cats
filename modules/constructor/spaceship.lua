function defaultSpaceship()
  local config = {
    name = "Default",

    -- Player / nave
    size = 5,
    scale = 1,
    maxHp = 1,

    -- Movimento
    speed = 600,

    -- Arma / projétil
    damage = 40,
    criticalChance = 0.10,
    criticalMultiplier = 1.5,

    hb = {
      type = "rectangle",
      width = 10,
      height = 5
    },

    firerate = 3,

    -- Outros atributos da nave
    planetRegen = 0.0,

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
      scale = 1
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

    -- Movimento
    speed = 300,

    -- Arma / projétil
    damage = 100,
    criticalChance = 0.10,
    criticalMultiplier = 1.5,

    hb = {
      type = "rectangle",
      width = 10,
      height = 5
    },

    firerate = 0.5,

    -- Outros atributos da nave
    planetRegen = 0.0,

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
      scale = 1
    },

    customHit = function(projectile, target)
      projectile:spawnExplosion(target)
    end
  }

  return Spaceship.new(config)
end