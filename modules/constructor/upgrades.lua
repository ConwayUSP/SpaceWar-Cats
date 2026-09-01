local colors = {
  base = { 1, 1, 1, 1 },
  highlight = { 0.561, 0.404, 0.859, 1 }
}

weights = {
  [COMMON] = 100,
  [RARE] = 40,
  [EPIC] = 15,
  [LEGENDARY] = 5
}

upgradesList = {
  {
    name = "FIRERATE II",
    rarity = RARE,
    description = {
      colors.base, "Spaceship fires ",
      colors.highlight, "15% ",
      colors.base, "faster!"
    },
    apply = function(ctx)
      ctx.player.spaceship.firerate = ctx.player.spaceship.firerate * 1.15
    end
  },
  {
    name = "FIRERATE III",
    rarity = EPIC,
    description = {
      colors.base, "Spaceship fires ",
      colors.highlight, "20% ",
      colors.base, "faster!"
    },
    apply = function(ctx)
      ctx.player.spaceship.firerate = ctx.player.spaceship.firerate * 1.2
    end
  },
  {
    name = "DAMAGE I",
    rarity = COMMON,
    description = {
      colors.base, "Increases projectile damage by ",
      colors.highlight, "8",
      colors.base, "!"
    },
    apply = function(ctx)
      ctx.player.spaceship.damage = ctx.player.spaceship.damage + 8
      ctx.player.spaceship:attWeapon()
    end
  },
  {
    name = "DAMAGE II",
    rarity = RARE,
    description = {
      colors.base, "Increases projectile damage by ",
      colors.highlight, "12",
      colors.base, "!"
    },
    apply = function(ctx)
      ctx.player.spaceship.damage = ctx.player.spaceship.damage + 12
      ctx.player.spaceship:attWeapon()
    end
  },
  {
    name = "DAMAGE III",
    rarity = EPIC,
    description = {
      colors.base, "Increases projectile damage by ",
      colors.highlight, "16",
      colors.base, "!"
    },
    apply = function(ctx)
      ctx.player.spaceship.damage = ctx.player.spaceship.damage + 16
      ctx.player.spaceship:attWeapon()
    end
  },
  {
    name = "CRITICAL I",
    rarity = COMMON,
    description = {
      colors.base, "Critical hit chance is ",
      colors.highlight, "4% ",
      colors.base, "higher!"
    },
    apply = function(ctx)
      ctx.player.spaceship.criticalChance = ctx.player.spaceship.criticalChance + 0.04
      ctx.player.spaceship:attWeapon()
    end
  },
  {
    name = "CRITICAL II",
    rarity = RARE,
    description = {
      colors.base, "Critical hit chance is ",
      colors.highlight, "8% ",
      colors.base, "higher!"
    },
    apply = function(ctx)
      ctx.player.spaceship.criticalChance = ctx.player.spaceship.criticalChance + 0.08
      ctx.player.spaceship:attWeapon()
    end
  },
  {
    name = "CRITICAL III",
    rarity = EPIC,
    description = {
      colors.base, "Critical hit chance is ",
      colors.highlight, "12% ",
      colors.base, "higher!"
    },
    apply = function(ctx)
      ctx.player.spaceship.criticalChance = ctx.player.spaceship.criticalChance + 0.12
      ctx.player.spaceship:attWeapon()
    end
  },
  {
    name = "SIZE I",
    rarity = COMMON,
    description = {
      colors.base, "Spaceship size is ",
      colors.highlight, "20% ",
      colors.base, "smaller!"
    },
    apply = function(ctx)
      ctx.player.spaceship.size = ctx.player.spaceship.size * 0.8
      ctx.player.spaceship.scale = ctx.player.spaceship.scale * 0.8
      ctx.player:newHitbox()
    end
  },
  {
    name = "PROJECTILE I",
    rarity = COMMON,
    description = {
      colors.base, "Projectiles are ",
      colors.highlight, "15% ",
      colors.base, "larger!"
    },
    apply = function(ctx)
      ctx.player.spaceship.hb = {
        type = "rectangle",
        width = ctx.player.spaceship.hb.width * 1.15,
        height = ctx.player.spaceship.hb.height * 1.15
      }

      ctx.player:attWeapon({
        scale = ctx.player.spaceship.weapon.scale * 1.15
      })
    end
  },
  {
    name = "PROJECTILE II",
    rarity = RARE,
    description = {
      colors.base, "Projectiles are ",
      colors.highlight, "30% ",
      colors.base, "larger!"
    },
    apply = function(ctx)
      ctx.player.spaceship.hb = {
        type = "rectangle",
        width = ctx.player.spaceship.hb.width * 1.30,
        height = ctx.player.spaceship.hb.height * 1.30
      }

      ctx.player:attWeapon({
        scale = ctx.player.spaceship.weapon.scale * 1.30
      })
    end
  },
  {
    name = "REGEN I",
    rarity = COMMON,
    description = {
      colors.base, "Planet regenerates ",
      colors.highlight, "+0.5 HP/s "
    },
    apply = function(ctx)
      ctx.planet.regen = ctx.planet.regen + 0.5
    end
  },
    {
    name = "REGEN II",
    rarity = RARE,
    description = {
      colors.base, "Planet regenerates ",
      colors.highlight, "+1 HP/s "
    },
    apply = function(ctx)
      ctx.planet.regen = ctx.planet.regen + 1
    end
  },
  {
    name = "CRIT DMG II",
    rarity = RARE,
    description = {
      colors.base, "Critical damage increases by ",
      colors.highlight, "15%",
      colors.base, "!"
    },
    apply = function(ctx)
      ctx.player.spaceship.criticalMultiplier = ctx.player.spaceship.criticalMultiplier + 0.15
      ctx.player.spaceship:attWeapon()
    end
  },
  {
    name = "CRIT DMG III",
    rarity = EPIC,
    description = {
      colors.base, "Critical damage increases by ",
      colors.highlight, "30%",
      colors.base, "!"
    },
    apply = function(ctx)
      ctx.player.spaceship.criticalMultiplier = ctx.player.spaceship.criticalMultiplier + 0.30
      ctx.player.spaceship:attWeapon()
    end
  },
  {
    name = "HEAL & HP I",
    rarity = COMMON,
    description = {
      colors.base, "Increases planet MAX HP and heal by ",
      colors.highlight, "10%!"
    },
    apply = function(ctx)
      local heal = ctx.planet.maxHp * 0.1
      ctx.planet.maxHp = ctx.planet.maxHp + heal
      ctx.planet:heal(heal)
    end
  },
  {
    name = "HEAL & HP II",
    rarity = RARE,
    description = {
      colors.base, "Increases planet MAX HP and heal by ",
      colors.highlight, "20%!"
    },
    apply = function(ctx)
      local heal = ctx.planet.maxHp * 0.2
      ctx.planet.maxHp = ctx.planet.maxHp + heal
      ctx.planet:heal(heal)
    end
  },
  {
    name = "HEAL & HP III",
    rarity = EPIC,
    description = {
      colors.base, "Increases planet MAX HP and heal by ",
      colors.highlight, "30%!"
    },
    apply = function(ctx)
      local heal = ctx.planet.maxHp * 0.3
      ctx.planet.maxHp = ctx.planet.maxHp + heal
      ctx.planet:heal(heal)
    end
  },
}