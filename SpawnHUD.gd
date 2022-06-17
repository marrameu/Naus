extends CanvasLayer


signal respawn

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func show():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Control.show()
	$Control/HBoxContainer/Button.grab_focus()


func _on_Button_pressed():
	emit_signal("respawn")
