local game = ...

function game:on_started()

  local hearts_class = require("hud/hearts")
  local magic_bar_class = require("hud/magic_bar")
  local rupees_class = require("hud/rupees")

  -- Set up the HUD.
  self.hud = {}

  self.hud.hearts = hearts_class:new(self)
  self.hud.hearts:set_dst_position(-104, 6)

  self.hud.magic_bar = magic_bar_class:new(self)
  self.hud.magic_bar:set_dst_position(-104, 27)

  self.hud.rupees = rupees_class:new(self)
  self.hud.rupees:set_dst_position(8, -20)

  self:set_hud_enabled(true)
end

-- Useful functions for this specific quest.

function game:get_player_name()
  return self:get_value("player_name")
end

function game:set_player_name(player_name)
  self:set_value("player_name", player_name)
end

function game:is_dungeon_finished(dungeon)
  return self:get_value("dungeon_" .. dungeon .. "_finished")
end

function game:set_dungeon_finished(dungeon, finished)
  if finished == nil then
    finished = true
  end
  self:set_value("dungeon_" .. dungeon .. "_finished", finished)
end

-- Returns whether the current map is in a dungeon.
function game:is_in_dungeon()
  return self:get_dungeon() ~= nil
end

-- Returns whether the current map is in the inside world.
function game:is_in_inside_world()
  return self:get_map():get_world() == "inside_world"
end

-- Returns whether the current map is in the outside world.
function game:is_in_outside_world()
  return self:get_map():get_world() == "outside_world"
end

-- Returns the index of the current dungeon if any, or nil.
function game:get_dungeon()

  local world = self:get_map():get_world()
  local index = world:match("^dungeon_([0-9]+)$")
  if index == nil then
    return nil
  end

  return tonumber(index)
end

-- Returns whether a small key counter exists on the current map.
function game:are_small_keys_enabled()
  return self:get_small_keys_savegame_variable() ~= nil
end

-- Returns the name of the integer variable that stores the number
-- of small keys for the current map, or nil.
function game:get_small_keys_savegame_variable()

  local map = self:get_map()

  -- Does the map explicitely defines a small key counter?
  if map.small_keys_savegame_variable ~= nil then
    return map.small_keys_savegame_variable
  end

  -- Are we in a dungeon?
  local dungeon = self:get_dungeon()
  if dungeon ~= nil then
    return "dungeon_" .. dungeon .. "_small_keys"
  end

  -- No small keys on this map.
  return nil
end

function game:is_hud_enabled()
  return self.hud_enabled
end

function game:set_hud_enabled(hud_enabled)

  if hud_enabled ~= game.hud_enabled then
    game.hud_enabled = hud_enabled

    for _, menu in pairs(self.hud) do
      if hud_enabled then
	sol.menu.start(self, menu)
      else
	sol.menu.stop(menu)
      end
    end
  end
end

-- Returns the item name of a bottle with the specified content, or nil.
function game:get_first_bottle_with(variant)

  for i = 1, 4 do
    local item = self:get_item("bottle_" .. i)
    if item:get_variant() == variant then
      return item
    end
  end

  return nil
end

function game:get_first_empty_bottle()
  return self:get_first_bottle_with(1)
end

function game:has_bottle()

  for i = 1, 4 do
    local item = self:get_item("bottle_" .. i)
    if item:has_variant() then
      return item
    end
  end

  return nil
end

function game:has_bottle_with(variant)

  return self:get_first_bottle_with(variant) ~= nil
end

-- Run the game.
sol.main.game = game
game:start()
