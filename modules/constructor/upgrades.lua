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
    name = "FIRERATE III",
    rarity = EPIC,
    description = {
      colors.base, "Spaceship fires ",
      colors.highlight, "20% ",
      colors.base, "faster!"
    },
    apply = function(ctx)
      ctx.player.firerate = ctx.player.firerate * 1.2
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
    name = "DAMAGE II",
    rarity = RARE,
    description = {
      colors.base, "Projectiles deal ",
      colors.highlight, "15% ",
      colors.base, "more damage!"
    },
    apply = function(ctx)
      ctx.player.damage = ctx.player.damage * 1.15
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
    name = "CRITICAL III",
    rarity = EPIC,
    description = {
      colors.base, "Critical hit chance is ",
      colors.highlight, "6% ",
      colors.base, "higher!"
    },
    apply = function(ctx)
      ctx.player.criticalChance = ctx.player.criticalChance + 0.06
      ctx.player:attWeapon()
    end
  },
  {
    name = "SIZE I",
    rarity = COMMON,
    description = {
      colors.base, "Spaceship size is ",
      colors.highlight, "10% ",
      colors.base, "smaller!"
    },
    apply = function(ctx)
      ctx.player.size = ctx.player.size * 0.9
      ctx.player.scale = ctx.player.scale * 0.9
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
    name = "SPEED III",
    rarity = EPIC,
    description = {
      colors.base, "Shots are ",
      colors.highlight, "16% ",
      colors.base, "faster!"
    },
    apply = function(ctx)
      ctx.player.speed = ctx.player.speed * 1.16
      ctx.player:attWeapon()
    end
  },
  {
    name = "REGEN I",
    rarity = COMMON,
    description = {
      colors.base, "Planet regenerates ",
      colors.highlight, "+1 HP/s "
    },
    apply = function(ctx)
      ctx.planet.regen = ctx.planet.regen + 1
    end
  },
    {
    name = "REGEN II",
    rarity = RARE,
    description = {
      colors.base, "Planet regenerates ",
      colors.highlight, "+2 HP/s "
    },
    apply = function(ctx)
      ctx.planet.regen = ctx.planet.regen + 2
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
      ctx.player.criticalMultiplier = ctx.player.criticalMultiplier + 0.15
      ctx.player:attWeapon()
    end
  },
  {
    name = "CRIT DMG III",
    rarity = EPIC,
    description = {
      colors.base, "Critical damage increases by ",
      colors.highlight, "25%",
      colors.base, "!"
    },
    apply = function(ctx)
      ctx.player.criticalMultiplier = ctx.player.criticalMultiplier + 0.25
      ctx.player:attWeapon()
    end
  },
  {
    name = "PLANET HP I",
    rarity = COMMON,
    description = {
      colors.base, "Increases planet MAX HP ",
      colors.highlight, "+10%"
    },
    apply = function(ctx)
      ctx.planet.maxHp = ctx.planet.maxHp * 1.1
      ctx.planet.hp = ctx.planet.hp * 1.1
    end
  },
  {
    name = "PLANET HP II",
    rarity = RARE,
    description = {
      colors.base, "Increases planet MAX HP ",
      colors.highlight, "+20%"
    },
    apply = function(ctx)
      ctx.planet.maxHp = ctx.planet.maxHp * 1.2
      ctx.planet.hp = ctx.planet.hp * 1.2
    end
  },
  {
    name = "PLANET HP III",
    rarity = EPIC,
    description = {
      colors.base, "Increases planet MAX HP ",
      colors.highlight, "+30%"
    },
    apply = function(ctx)
      ctx.planet.maxHp = ctx.planet.maxHp * 1.3
      ctx.planet.hp = ctx.planet.hp * 1.3
    end
  },
}