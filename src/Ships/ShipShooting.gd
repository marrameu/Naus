extends Node

var shoot_range := 1500

# Bullets
const bullet_scene : PackedScene = preload("res://src/Bullets/Ships/ShipBullet.tscn")
const secondary_bullet_scene : PackedScene = preload("res://src/Bullets/Ships/ShipBullet2.tscn")

# Timers, fer-ho amb arrays?
var fire_rates := { 0 : 4.0, 1 : 2.0 }
var next_times_to_fire := { 0 : 0.0, 1 : 0.0}
var time_now := 0.0

var shoot_action := "shoot"
var zoom_action := "zoom"

var can_shoot_pri := true
var can_shoot_sec := true


func _ready() -> void:
	pass


func _process(delta : float) -> void:
	time_now += delta
	
	can_shoot_pri = time_now >= next_times_to_fire[0]
	can_shoot_sec = time_now >= next_times_to_fire[1]



sync func shoot(bullet_type : int, shoot_target) -> void:
	next_times_to_fire[bullet_type] = time_now + 1.0 / fire_rates[bullet_type]
	
	# Sound
	if bullet_type == 0:
		$Audio.play()
	elif bullet_type == 1:
		$Audio2.play()
	
	var bullet : KinematicBody
	if bullet_type == 0:
		bullet = bullet_scene.instance()
	elif bullet_type == 1:
		bullet = secondary_bullet_scene.instance()
	get_node("/root/Level").add_child(bullet)
	var shoot_from : Vector3 = get_parent().global_transform.origin # Canons
	bullet.global_transform.origin = shoot_from
	bullet.direction = (shoot_target - shoot_from).normalized()
	bullet.look_at(shoot_target, Vector3.UP)
	bullet.ship = get_parent()
