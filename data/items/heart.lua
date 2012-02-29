
function event_appear(variant, savegame_variable, falling_height)

  if falling_height ~= 0 then
    local trajectory = "0 0  0 -2  0 -2  0 -2  0 -2  0 -2  0 0  0 0  1 1  1 1  1 0  1 1  1 1  0 0  -1 0  -1 1  -1 0  -1 1  -1 0  -1 1  0 1  1 1  1 1  -1 0"
    local m = sol.movement.pixel_movement_create(trajectory, 100)
    m:set_property("loop", false)
    m:set_property("ignore_obstacles", true)
    sol.item.start_movement(m)
  end
end

