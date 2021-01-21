extends Node2D

remote func update_player(transform):
	rpc_unreliable("update_remote_player", transform)
