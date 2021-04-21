extends Node2D

const PLAYER = preload("res://player/player.tscn")
const ENEMY = preload("res://enemy/enemy.tscn")

var possible_destinations
var game_ended = false

onready var player_spawn = $PlayerSpawn
onready var players = $Players
onready var destinations = $EnemySpawn
onready var enemies = $Enemies
onready var victory_status = $CanvasLayer/GUI/CenterContainer/Label
onready var animation_player = $AnimationPlayer
onready var reset_timer = $ResetGame

func _ready():
	possible_destinations = destinations.get_children()
	rpc_id(1, "spawn_players", Server.local_player_id)
	
func _process(delta):
	if players.get_children().size() == 1 and !game_ended:
		game_ended = true
		show_gui("Player " + Server.players[int(players.get_child(0).name)]["Player_name"] + " Won")
		reset_timer.start()
	
	
remote func spawn_player(id):
	var player = PLAYER.instance()
	player.name = str(id)
	players.add_child(player)
	player.set_network_master(id)
	player.position = player_spawn.position
	

remote func spawn_enemy(idx, enemy_name):
	var new_destination = possible_destinations[idx]
	var enemy_instance = ENEMY.instance()
	enemy_instance.name = enemy_name
	enemies.add_child(enemy_instance)
	enemy_instance.position = new_destination.position
	

func _on_EnemySpawnTimer_timeout():
	rpc_id(1, "spawn_enemies", possible_destinations.size())
	
func show_gui(status):
	animation_player.play("gui")
	victory_status.text = status


func _on_ResetGame_timeout():
	Server.end_game()
	
func delete_player(id):
	players.get_node(str(id)).queue_free()
