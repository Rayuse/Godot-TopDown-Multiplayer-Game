extends KinematicBody2D

const MAXSPEED = 100
const ACCELERATION = 300
const FRICTION = 200

var motion = Vector2.ZERO

onready var player_label = $Label
onready var camera = $Camera2D

func _ready():
	player_label.set_as_toplevel(true)
	set_player_name()

func _physics_process(delta):
	if is_network_master():
		camera.current = true
		player_label.rect_position = Vector2(position.x - 40, position.y - 60)
		var input_vector = get_input_vector()
		print(input_vector)
		apply_movement(input_vector, delta)
		apply_friction(input_vector, delta)
		motion = move_and_slide(motion)
		
		rpc_unreliable_id(1, "update_player", global_transform)
		
remote func update_remote_player(transform):
	if not is_network_master():
		global_transform = transform
		player_label.rect_position = Vector2(position.x - 40, position.y - 60)
		
	
	
func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return input_vector.normalized()
	
	
func apply_movement(input_vector, delta):
	look_at(get_global_mouse_position())
	if input_vector != Vector2.ZERO:
		motion = motion.move_toward(input_vector * MAXSPEED, ACCELERATION * delta)

		
func apply_friction(input_vector, delta):
	if input_vector == Vector2.ZERO:
		motion = motion.move_toward(Vector2.ZERO, FRICTION * delta)
		
func set_player_name ():
	player_label.text = Server.players[int(name)]["Player_name"]

