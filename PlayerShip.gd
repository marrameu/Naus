extends Ship

var cam : Camera

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	input_to_physics(delta)
	check_collisions(delta)
	update_thruster_flame()
	
	if Utilities.first_person:
		$ShipMesh.visible = false
		$PlayerShipInterior.visible = true
	else:
		$ShipMesh.visible = true
		$PlayerShipInterior.visible = false
