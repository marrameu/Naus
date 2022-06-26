extends RigidBody
class_name Ship

signal ship_died

export var red_mat : Material
export var blue_mat : Material

onready var input : Node = $Input # class per a linput i el physics
onready var physics : Node = $Physics

var  pilot_man : PilotManager


func _ready():
	set_team_color()


func _process(delta):
	input_to_physics(delta)
	check_collisions()
	update_thruster_flame()


func set_team_color():
	if pilot_man.blue_team:
		$ShipMesh/Cube.material_override = blue_mat
		$ShipMesh/Cube001.material_override = blue_mat
	else:
		$ShipMesh/Cube.material_override = red_mat
		$ShipMesh/Cube001.material_override = red_mat


func update_thruster_flame():
	var b = transform.basis
	var v_len = linear_velocity.length()
	var v_nor = linear_velocity.normalized()
	var vel : Vector3
	vel.z = b.z.dot(v_nor) * v_len
	$ShipMesh/ThrusterFlame.Speed = max(0.1, vel.z / 100)
	$ShipMesh/ThrusterFlame.Intensity = max(0.1, vel.z / 200)
	$ShipMesh/ThrusterFlame.Energy = max(0.1, vel.z / 100)


func input_to_physics(delta):
	var final_linear_input := Vector3(input.strafe, 0.0, input.throttle)
	var final_angular_input :=  Vector3(input.pitch, input.yaw, input.roll)
	physics.set_physics_input(final_linear_input, final_angular_input, delta)


func check_collisions():
	if get_colliding_bodies().size() > 0:
		for body in get_colliding_bodies():
			#if not body.is_in_group("Bullets"):
			#Input.start_joy_vibration(0, 0, 1, 1)
			$HealthSystem.take_damage(INF, true)


func _on_HealthSystem_die():
	print(name + "died")
	
	# animacions
	
	emit_signal("ship_died")
	
	queue_free()
	
	
