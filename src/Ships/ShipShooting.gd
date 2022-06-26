extends Node

var shoot_range := 1500

# Bullets
const bullet_scene : PackedScene = preload("res://src/Bullets/Ships/ShipBullet.tscn")
const secondary_bullet_scene : PackedScene = preload("res://src/Bullets/Ships/ShipBullet2.tscn")

# Timers, fer-ho amb arrays?
var fire_rates := { 0 : 4.0, 1 : 2.0 }
var next_times_to_fire := { 0 : 0.0, 1 : 0.0}
var time_now := 0.0

var can_shoot := true

var current_bullet := 0


func _ready() -> void:
	pass


func _process(delta : float) -> void:
	time_now += delta
	
	can_shoot = time_now >= next_times_to_fire[current_bullet] and not owner.input.turboing



sync func shoot(shoot_target = Vector3.ZERO) -> void:
	next_times_to_fire[current_bullet] = time_now + 1.0 / fire_rates[current_bullet]
	
	# Sound fer-ho pel nom com els pilotman
	if current_bullet == 0:
		$Audio.play()
	elif current_bullet == 1:
		$Audio2.play()
	
	var bullet : KinematicBody
	if current_bullet == 0:
		bullet = bullet_scene.instance()
	elif current_bullet == 1:
		bullet = secondary_bullet_scene.instance()
	get_node("/root/Level").add_child(bullet)
	var shoot_from : Vector3 = get_parent().global_transform.origin # Canons
	bullet.global_transform.origin = shoot_from
	if shoot_target:
		bullet.direction = (shoot_target - shoot_from).normalized()
		bullet.look_at(shoot_target, Vector3.UP)
	else:
		bullet.direction = owner.global_transform.basis.z
		bullet.look_at(owner.global_transform.origin + owner.global_transform.basis.z, Vector3.UP)
	bullet.ship = get_parent()

