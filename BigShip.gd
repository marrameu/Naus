extends StaticBody


signal destroyed

export var team_blue : bool = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HealthSystem_die():
	emit_signal("destroyed", team_blue)
	queue_free()
