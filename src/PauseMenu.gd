extends Control


var is_paused = false setget set_is_paused


# Called when the node enters the scene tree for the first time.
func _ready():
	$OptionsMenu.hide()
	hide()

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.is_paused = !is_paused

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused
	
	if get_tree().paused:
		
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)





func _on_Reprendre_pressed():
	self.is_paused = false


func _on_Opcions_pressed():
	$MenuPrincipal.hide()
	$OptionsMenu.show()


func _on_Sortir_pressed():
	get_tree().quit()
