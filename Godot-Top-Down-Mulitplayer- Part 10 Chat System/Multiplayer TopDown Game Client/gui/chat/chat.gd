extends CanvasLayer

var max_messages = 6

onready var message = $Message
onready var typed_message = $Message/TypedMessage
onready var chat_box = $ChatBox


func _input(event):
	if event.is_action_pressed("ui_accept"):
		if message.visible:
			if typed_message.text != "":
				Server.add_to_chat(typed_message.text)
			message.visible = false
			typed_message.clear()
			typed_message.release_focus()
		else:
			message.visible = true
			typed_message.grab_focus()
		
func _process(delta):
	if chat_box.get_child_count() > max_messages:
		chat_box.get_child(0).queue_free()
		
func message(player_name, data):
	var display_message = Label.new()
	chat_box.add_child(display_message)
	display_message.text = "%s : %s" % [player_name, data]
