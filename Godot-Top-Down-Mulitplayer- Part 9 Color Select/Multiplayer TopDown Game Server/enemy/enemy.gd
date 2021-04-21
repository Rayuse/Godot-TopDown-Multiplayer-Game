extends Node2D

onready var players = get_tree().get_root().find_node("Players", true, false)

func _ready():
	randomize()
	
remote func select_target():
	var num_players = players.get_children().size()
	var player_idx = randi() % num_players
	rpc("select_player_target", player_idx)
	
remote func destory_enemy():
	queue_free()
	
remote func remove_player(player):
	players.remove_child(players.get_node(player))
	
	

