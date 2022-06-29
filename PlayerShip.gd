extends Ship

var cam : Camera

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Utilities.first_person:
		$ShipMesh.visible = false
		$PlayerShipInterior.visible = true
	else:
		$ShipMesh.visible = true
		$PlayerShipInterior.visible = false
