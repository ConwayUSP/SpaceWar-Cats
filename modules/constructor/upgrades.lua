local colors = {
  base = {1, 1, 1, 1},
  highlight = {0.561, 0.404, 0.859, 1}
}

weights = {
  [COMMON] = 100,
  [RARE] = 40,
  [EPIC] = 15,
  [LEGENDARY] = 5
}

upgradesList = {
  {
    name = "FIRERATE I",
    rarity = COMMON,
    description = {
      colors.base, "Spaceship fires ",
      colors.highlight, "10% ",
      colors.base, "faster!"
    },
    apply = function(ctx)
      ctx.player.firerate = ctx.player.firerate * 1.1
    end
  },
  {
    name = "FIRERATE II",
    rarity = RARE,
    description = {
      colors.base, "Spaceship fires ",
      colors.highlight, "15% ",
      colors.base, "faster!"
    },
    apply = function(ctx)
      ctx.player.firerate = ctx.player.firerate * 1.15
    end
  },
  {
    name = "DAMAGE I",
    rarity = COMMON,
    description = {
      colors.base, "Projectiles deal ",
      colors.highlight, "10% ",
      colors.base, "more damage!"
    },
    apply = function(ctx)
      ctx.player.damage = ctx.player.damage * 1.1
      ctx.player:attWeapon()
    end
  },
  {
    name = "CRITICAL I",
    rarity = COMMON,
    description = {
      colors.base, "Critical hit chance is ",
      colors.highlight, "2% ",
      colors.base, "higher!"
    },
    apply = function(ctx)
      ctx.player.criticalChance = ctx.player.criticalChance + 0.02
      ctx.player:attWeapon()
    end
  },
  {
    name = "CRITICAL II",
    rarity = RARE,
    description = {
      colors.base, "Critical hit chance is ",
      colors.highlight, "4% ",
      colors.base, "higher!"
    },
    apply = function(ctx)
      ctx.player.criticalChance = ctx.player.criticalChance + 0.04
      ctx.player:attWeapon()
    end
  },
  {
    name = "SIZE I",
    rarity = COMMON,
    description = {
      colors.base, "Spaceship size is ",
      colors.highlight, "8% ",
      colors.base, "smaller!"
    },
    apply = function(ctx)
      ctx.player.size = ctx.player.size * 0.92
      ctx.player.scale = ctx.player.scale * 0.92
      ctx.player:newHitbox()
    end
  },
  {
    name = "PROJECTILE I",
    rarity = COMMON,
    description = {
      colors.base, "Projectiles are ",
      colors.highlight, "8% ",
      colors.base, "larger!"
    },
    apply = function(ctx)
      ctx.player.hb = {
        type = "rectangle",
        width = ctx.player.hb.width * 1.08,
        height = ctx.player.hb.height * 1.08
      }
      
      ctx.player:attWeapon({
        scale = ctx.player.weapon.scale * 1.08
      })
    end
  },
  {
    name = "SPEED I",
    rarity = COMMON,
    description = {
      colors.base, "Shots are ",
      colors.highlight, "8% ",
      colors.base, "faster!"
    },
    apply = function(ctx)
      ctx.player.speed = ctx.player.speed * 1.08
      ctx.player:attWeapon()
    end
  },
  {
    name = "SPEED II",
    rarity = RARE,
    description = {
      colors.base, "Shots are ",
      colors.highlight, "12% ",
      colors.base, "faster!"
    },
    apply = function(ctx)
      ctx.player.speed = ctx.player.speed * 1.12
      ctx.player:attWeapon()
    end
  },
  {
    name = "REGEN I",
    rarity = COMMON,
    description = {
      colors.base, "Planet regenerates ",
      colors.highlight, "+5 HP/s "
    },
    apply = function(ctx)
      ctx.planet.regen = ctx.planet.regen + 5
    end
  },
  {
    name = "CRIT DMG II",
    rarity = RARE,
    description = {
      colors.base, "Critical damage inscreases by ",
      colors.highlight, "15%",
      colors.base, "!"
    },
    apply = function(ctx)
      ctx.player.criticalMultiplier = ctx.player.criticalMultiplier + 0.15
      ctx.player:attWeapon()
    end
  },
}