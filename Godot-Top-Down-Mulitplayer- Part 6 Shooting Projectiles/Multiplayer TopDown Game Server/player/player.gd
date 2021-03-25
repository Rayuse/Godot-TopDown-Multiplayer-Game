extends Node2D

remote func update_player(transform):
	rpc_unreliable("update_remote_player", transform)
	
remote func player_bullet():
	rpc("spawn_bullet")
