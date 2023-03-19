local function enable_expansion(player)
  _G.game.map_settings.enemy_expansion.enabled = true
  player.print({"biter-expansion-toggle.expansion-enabled"})
end

local function disable_expansion(player)
  _G.game.map_settings.enemy_expansion.enabled = false
  player.print({"biter-expansion-toggle.expansion-disabled"})
end

local function toggle_expansion(player)
  local enabled = _G.game.map_settings.enemy_expansion.enabled
  if enabled then
    disable_expansion(player)
  else
    enable_expansion(player)
  end
end

_G.commands.add_command("toggle_expansion", {"biter-expansion-toggle.toggle-cmd-help"}, function(command)
  local player = _G.game.get_player(command.player_index)
  toggle_expansion(player)
end)
