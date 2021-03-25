extends Area2D

export var speed = 400

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_PlayerBullet_area_entered(area):
	queue_free()


func _on_PlayerBullet_body_entered(body):
	if not body.is_in_group("Player"):
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
