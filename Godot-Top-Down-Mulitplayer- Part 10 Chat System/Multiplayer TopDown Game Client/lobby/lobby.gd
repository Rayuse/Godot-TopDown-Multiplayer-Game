extends Control

onready var player_name = $CenterContainer/VBoxContainer/GridContainer/NameTextBox
onready var selected_IP = $CenterContainer/VBoxContainer/GridContainer/IPTextBox
onready var selected_port = $CenterContainer/VBoxContainer/GridContainer/PortTextBox
onready var waiting_room = $WaitingRoom
onready var ready_btn = $WaitingRoom/CenterContainer/VBoxContainer/ReadyBtn
onready var color_picker = $CenterContainer/VBoxContainer/GridContainer/ColorPickerButton

func _ready():
	player_name.text = Save.save_data["Player_name"]
	selected_IP.text = Server.DEFAULT_IP
	selected_port.text = str(Server.DEFAULT_PORT)
	color_picker.color = Save.save_data["local_color"]

func _on_JoinBtn_pressed():
	Server.selected_IP = selected_IP.text
	Server.selected_port = int(selected_port.text)
	Server._connect_to_server()
	show_waiting_room()


func _on_NameTextBox_text_changed(new_text):
	Save.save_data["Player_name"] = player_name.text
	Save.save_game()
	
func show_waiting_room():
	waiting_room.popup_centered()


func _on_ReadyBtn_pressed():
	Server.load_game()
	ready_btn.disabled = true


func _on_ColorPickerButton_color_changed(color):
	Save.save_data["local_color"] = color.to_html()
	Save.save_game()
