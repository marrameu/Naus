extends Node


var mouse_sensitivity := 75.0
var joystick_sensitivity := 0.6
var controller_input := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("change_input"):
		controller_input = !controller_input

func toggle_fullscreen(toggle):
	OS.window_fullscreen = toggle
