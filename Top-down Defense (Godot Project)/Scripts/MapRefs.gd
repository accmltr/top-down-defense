extends Node

var map# Set by map._ready()

func game_manager(): return map.game_manager
func base(): return map.base
func pathfinder(): return map.map_pathfinder
func enemies_manager(): return map.enemies_manager
func player_structs_manager(): return map.player_structs_manager
func wave_maker(): return map.wave_maker
