---@param player LuaPlayer?
local function print(player, ...)
  if player then
    player.print(...)
  else
    game.print(...)
  end
end

---@param player LuaPlayer?
---@return boolean
local function check_admin(player)
  local is_admin = player == nil or player.admin
  if not is_admin then
    print(player, {"biter-expansion-toggle.not-admin"})
  end

  return is_admin
end

---@return boolean
local function is_expansion_enabled()
  return game.map_settings.enemy_expansion.enabled
end

---@return boolean
local function is_disabling_allowed()
  return settings.global["biter-expansion-toggle-allow-disabling"].value == true
end

---@param player LuaPlayer?
---@param state boolean
local function set_shortcut_state(player, state)
  if not player then return end
  player.set_shortcut_toggled("biter-expansion-toggle-shortcut", state)
  local can_disable = is_disabling_allowed()
  if can_disable then
    player.set_shortcut_available("biter-expansion-toggle-shortcut", true)
  elseif state then
    player.set_shortcut_available("biter-expansion-toggle-shortcut", false)
  end
end

---@param player LuaPlayer?
local function enable_expansion(player)
  if not check_admin(player) then return end
  game.map_settings.enemy_expansion.enabled = true
  print(player, {"biter-expansion-toggle.expansion-enabled"})
  set_shortcut_state(player, true)
end

---@param player LuaPlayer?
local function disable_expansion(player)
  if not check_admin(player) then return end
  if not settings.global["biter-expansion-toggle-allow-disabling"].value then
    print(player, {"biter-expansion-toggle.expansion-disabling-not-allowed"})
    set_shortcut_state(player, true)
    return
  end
  game.map_settings.enemy_expansion.enabled = false
  print(player, {"biter-expansion-toggle.expansion-disabled"})
  set_shortcut_state(player, false)
end

---@param player LuaPlayer?
local function toggle_expansion(player)
  local enabled = is_expansion_enabled()
  if enabled then
    disable_expansion(player)
  else
    enable_expansion(player)
  end
end

commands.add_command("biter-expansion", {"biter-expansion-toggle.cmd-help"}, function(command)
  local player = game.get_player(command.player_index)
  local arg = command.parameter
  if arg == "toggle" then
    toggle_expansion(player)
  elseif arg == "enable" then
    enable_expansion(player)
  elseif arg == "disable" then
    disable_expansion(player)
  else
    local enabled = is_expansion_enabled()
    if enabled then
      print(player, {"biter-expansion-toggle.expansion-is-enabled"})
    else
      print(player, {"biter-expansion-toggle.expansion-is-disabled"})
    end
  end
end)

script.on_event(defines.events.on_player_created, function(event)
  local player = game.get_player(event.player_index)
  if not player then return end
  set_shortcut_state(player, is_expansion_enabled())
end)

script.on_event(defines.events.on_lua_shortcut, function(event)
  if event.prototype_name ~= "biter-expansion-toggle-shortcut" then return end
  local player = game.get_player(event.player_index)
  toggle_expansion(player)
end)

script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
  if event.setting ~= "biter-expansion-toggle-allow-disabling" then return end
  local enabled = is_expansion_enabled()
  for _, player in pairs(game.players) do
    set_shortcut_state(player, enabled)
  end
end)
