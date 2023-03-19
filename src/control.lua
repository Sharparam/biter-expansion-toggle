local function print(player, ...)
  if player then
    player.print(...)
  else
    game.print(...)
  end
end

local function enable_expansion(player)
  game.map_settings.enemy_expansion.enabled = true
  print(player, {"biter-expansion-toggle.expansion-enabled"})
end

local function disable_expansion(player)
  if not settings.global["biter-expansion-toggle-allow-disabling"].value then
    print(player, {"biter-expansion-toggle.expansion-disabling-not-allowed"})
    return
  end
  game.map_settings.enemy_expansion.enabled = false
  print(player, {"biter-expansion-toggle.expansion-disabled"})
end

local function toggle_expansion(player)
  local enabled = game.map_settings.enemy_expansion.enabled
  if enabled then
    disable_expansion(player)
  else
    enable_expansion(player)
  end
end

_G.commands.add_command("toggle_expansion", {"biter-expansion-toggle.toggle-cmd-help"}, function(command)
  local player = game.get_player(command.player_index)
  toggle_expansion(player)
end)
