extends KinematicBody

signal destroyed

export var red_mat : Material
export var blue_mat : Material

export var blue_team : bool = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if blue_team:
		$Mesh.material_override = blue_mat
	else:
		$Mesh.material_override = red_mat


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HealthSystem_die():
	emit_signal("destroyed", blue_team)
	queue_free()


func _on_HealthSystem_shield_die():
	$ShieldMesh.hide()


func _on_HealthSystem_shield_recovered():
	$ShieldMesh.show()
