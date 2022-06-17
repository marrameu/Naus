extends RigidBody

signal player_died

var input : Node # class per al input
var physics : Node

var team_blue := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# no cal fer tot açò si no ets server
	# match
	if not input: # s'ha de desassignar, llavors; o fer-ho per senyals
		input = $PlayerInput # export var
	if not physics:
		physics = $Physics
	
	physics.wants_turbo = Input.is_action_pressed(input.turbo_action)
	
	var final_linear_input := Vector3(input.strafe, 0.0, input.throttle)
	var final_angular_input :=  Vector3(input.pitch, input.yaw, input.roll)
	physics.set_physics_input(final_linear_input, final_angular_input, delta)
	
	if get_colliding_bodies().size() > 0:
		for body in get_colliding_bodies():
			#if not body.is_in_group("Bullets"):
			Input.start_joy_vibration(0, 0, 1, 1)
			$HealthSystem.take_damage(INF, true)
	
	if Utilities.first_person:
		$ShipMesh.visible = false
		$PlayerShipInterior.visible = true
	else:
		$ShipMesh.visible = true
		$PlayerShipInterior.visible = false


func _on_HealthSystem_die():
	print("i die")
	
	# animacions
	
	emit_signal("player_died")
	
	queue_free()
	
	
