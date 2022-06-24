extends RigidBody

signal ship_died

export var red_mat : Material
export var blue_mat : Material

var input : Node # class per al input
var physics : Node

var  pilot_man : PilotManager

#export var team_blue := false

func _ready():
	if pilot_man.blue_team:
		$ShipMesh/Cube.material_override = blue_mat
		$ShipMesh/Cube001.material_override = blue_mat
	else:
		$ShipMesh/Cube.material_override = red_mat
		$ShipMesh/Cube001.material_override = red_mat


func _process(delta):
	# no cal fer tot açò si no ets server
	# match
	if not input: # s'ha de desassignar, llavors; o fer-ho per senyals
		input = $Input # export var
	if not physics:
		physics = $Physics
	
	
	var final_linear_input := Vector3(input.strafe, 0.0, input.throttle)
	var final_angular_input :=  Vector3(input.pitch, input.yaw, input.roll)
	physics.set_physics_input(final_linear_input, final_angular_input, delta)
	
	if get_colliding_bodies().size() > 0:
		for body in get_colliding_bodies():
			#if not body.is_in_group("Bullets"):
			#Input.start_joy_vibration(0, 0, 1, 1)
			$HealthSystem.take_damage(INF, true)
	
	if Utilities.first_person:
		$ShipMesh.visible = false
		$PlayerShipInterior.visible = true
	else:
		$ShipMesh.visible = true
		$PlayerShipInterior.visible = false
		var b = transform.basis
		var v_len = linear_velocity.length()
		var v_nor = linear_velocity.normalized()
		var vel : Vector3
		vel.z = b.z.dot(v_nor) * v_len
		$ShipMesh/ThrusterFlame.Speed = max(0.1, vel.z / 100)
		$ShipMesh/ThrusterFlame.Intensity = max(0.1, vel.z / 200)
		$ShipMesh/ThrusterFlame.Energy = max(0.1, vel.z / 100)



func _on_HealthSystem_die():
	print(name + "died")
	
	# animacions
	
	emit_signal("ship_died")
	
	queue_free()
	
	
