local enemy = ...

-- Gibdo.

require("enemies/generic_towards_hero")(enemy)
enemy:set_properties({
  sprite = "enemies/gibdo",
  life = 8,
  damage = 8,
  normal_speed = 40,
  faster_speed = 48,
  pushed_when_hurt = false
})

