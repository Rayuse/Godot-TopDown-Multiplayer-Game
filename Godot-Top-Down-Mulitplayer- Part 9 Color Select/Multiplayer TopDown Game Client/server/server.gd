extends Node

const DEFAULT_IP = "127.0.0.1"
const DEFAULT_PORT = 3234

var network = NetworkedMultiplayerENet.new()
var selected_IP
var selected_port

var local_player_id = 0
sync var players = {}
sync var player_data = {}

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
func _connect_to_server():
	get_tree().connect("connected_to_server", self, "_connected_ok")
	network.create_client(selected_IP, selected_port)
	get_tree().set_network_peer(network)
	
func _player_connected(id):
	print("Player: " + str(id) + " Connected")
	
func _player_disconnected(id):
	print("Player: " + str(id) + " Disconnected")
	if get_tree().get_root().has_node("World"):
		get_tree().get_root().get_node("World").delete_player(id)
	
func _connected_ok():
	print("Successfully connected to server")
	register_player()
	rpc_id(1, "send_player_info", local_player_id, player_data)
	
func _connected_fail():
	print("Failed to connect")
	
func _server_disconnected():
	print("Server Disconnected")
	
func register_player():
	local_player_id = get_tree().get_network_unique_id()
	player_data = Save.save_data
	players[local_player_id] = player_data
	
sync func update_waiting_room():
	get_tree().call_group("WaitingRoom", "refresh_players", players)
	
func load_game():
	rpc_id(1, "load_world")
	
sync func start_game():
	var world = preload("res://world/world.tscn").instance()
	get_tree().get_root().add_child(world)
	get_tree().get_root().get_node("Lobby").queue_free()
	
func end_game():
	rpc_id(1, "game_ended")
	var world = get_node("/root/World")
	if has_node("/root/World"):
		world.queue_free()
	get_tree().change_scene("res://lobby/lobby.tscn")
	network.close_connection()
	get_tree().disconnect("connected_to_server", self, "_connected_ok")
	get_tree().set_network_peer(null)
	
	
	
	
	
	
	
