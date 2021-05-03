extends KinematicBody2D

const MAXSPEED = 80
const ACCELERATION = 300

var motion = Vector2.ZERO
var possible_players
var target_player

onready var players = get_tree().get_root().find_node("Players", true, false)
onready var world = get_tree().root.get_node("World")

func _ready():
	possible_players = players.get_children()
	target_player = possible_players[0]
	rpc_id(1, "select_target")
	
	
remote func select_player_target(idx):
	target_player = possible_players[idx]
	
	
func _physics_process(delta):
	if target_player != null:
		var player_direction = (target_player.position - global_position).normalized()
		motion = motion.move_toward(player_direction * MAXSPEED, ACCELERATION * delta)
	else: 
		motion = Vector2.ZERO
	motion = move_and_slide(motion)


func _on_PlayerDetection_body_entered(body):
	if body.is_in_group('Player'):
		target_player = body


func _on_HurtBox_area_entered(area):
	if area.is_in_group("Bullet"):
		rpc_id(1, "destroy_enemy")
		queue_free()


func _on_HitBox_body_entered(body):
	if body.is_in_group("Player"):
		body.damage()
		if players.get_children().size() > 1:
			rpc_id(1, "remove_player", body.name)
			players.remove_child(body)
		rpc_id(1, "select_target")
		
