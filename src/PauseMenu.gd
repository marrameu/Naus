extends CanvasLayer


var is_paused = false setget set_is_paused


# Called when the node enters the scene tree for the first time.
func _ready():
	hide_default()


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.is_paused = !is_paused
	
	if event.is_action_pressed("ui_cancel"):
		self.is_paused = false


func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	hide_default()
	$Control.visible = is_paused
	
	if get_tree().paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$Control/MenuPrincipal/Reprendre.grab_focus()
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)



func _on_Reprendre_pressed():
	self.is_paused = false


func _on_Opcions_pressed():
	$Control/MenuPrincipal.hide()
	$Control/OptionsMenu.show()
	$Control/OptionsMenu/MarginContainer/VBoxContainer/TabContainer/GRAPHICS/MarginContainer/HBoxContainer/VBoxContainer/PanelContainer/DisplayMode/DisplayMode2.grab_focus()


func _on_Sortir_pressed():
	get_tree().quit()


func hide_default():
	$Control/OptionsMenu.hide()
	$Control.hide()
	$Control/MenuPrincipal.show()
