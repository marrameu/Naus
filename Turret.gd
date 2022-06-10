extends Spatial

var enemies = []
const bullet_scene : PackedScene = preload("res://src/Bullets/Ships/ShipBullet.tscn")

var fire_rate := 2.0
var next_time_to_fire := 0.0
var time_now := 0.0

onready var ray : RayCast = $Spatial/RayCast

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# rotate
	if enemies:
		# make it slerp
		$Spatial.look_at(enemies[0].translation, $Spatial.global_transform.basis.y)
		$Spatial.rotation_degrees.z = 0
		$Spatial.rotation_degrees.x = clamp($Spatial.rotation_degrees.x, -50, 50)
		$Spatial.rotation_degrees.y = clamp($Spatial.rotation_degrees.y, -50, 50)


func _process(delta):
	time_now += delta
	
	# raycast
	if enemies:
		if ray.is_colliding() and ray.get_collider() == enemies[0]:
			if time_now >= next_time_to_fire:
				next_time_to_fire = time_now + 1.0 / fire_rate
				if get_tree().has_network_peer():
					rpc("shoot")
				else:
					shoot()


func _on_Area_body_entered(body):
	print(body)
	if body.is_in_group("Ships"):
		enemies.push_back(body)
		print(name + " a matar " + body.name)


sync func shoot() -> void:
	# Sound
	$Audio.play()
	
	var bullet : KinematicBody
	bullet = bullet_scene.instance()
	
	get_node("/root/Level").add_child(bullet)
	var shoot_from : Vector3 = global_transform.origin # Canons
	bullet.global_transform.origin = shoot_from
	bullet.direction = -$Spatial.global_transform.basis.z
	bullet.look_at($Spatial.global_transform.origin + -$Spatial.global_transform.basis.z, Vector3.UP)
	bullet.ship = get_parent()


func _on_Area_body_exited(body):
	var a := 0
	for enemie in enemies:
		if enemie == body:
			enemies.remove(a)
			break
		a += 1
