extends CanvasLayer


signal respawn
signal start_battle

export var battle_state_path : NodePath 
onready var battle_state = get_node(battle_state_path)


var waiting := false


# Called when the node enters the scene tree for the first time.
func _ready():
	show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if waiting:
		$Control/WaitTime.text = "ESPEREU " + str(int($PlayerRespawnTimer.time_left)) + "\""


func show():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Control.show()
	$Control/StartButton.hide()
	$Control/HBoxContainer.show()
	
	$Control/HBoxContainer/Button.grab_focus()


func _on_Button_pressed():
	$Control/StartButton.show()
	$Control/HBoxContainer.hide()
	$Control/StartButton.grab_focus()


func _on_StartButton_pressed():
	# if battle_state.battle_started # NO CAL
	emit_signal("start_battle")
	emit_signal("respawn")


func enable_spawn(enable : bool):
	if enable:
		$Control/StartButton.disabled = false
		$Control/WaitTime.visible = false
		waiting = false
	else:
		waiting = true
		$Control/StartButton.disabled = true
		$PlayerRespawnTimer.start()
		$Control/WaitTime.visible = true
