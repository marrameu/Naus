extends Node

onready var lock_missile_timer : Timer = $LockMissileTimer

var shoot_range := 1500

# Bullets
const bullet_scene : PackedScene = preload("res://src/Bullets/Ships/ShipBullet.tscn")
const secondary_bullet_scene : PackedScene = preload("res://src/Bullets/Ships/ShipBullet2.tscn")

# Timers, fer-ho amb arrays?
var fire_rates := { 0 : 4.0, 1 : 2.0 }
var next_times_to_fire := { 0 : 0.0, 1 : 0.0}
var time_now := 0.0

var wants_shoot := false

var MAX_AMMO :=  50.0
var ammo := MAX_AMMO
var not_eased_ammo := ammo

var MAX_MISSILES_AMMO :=  4
var missiles_ammmo := MAX_AMMO

var can_shoot := true

var current_bullet := 0

var old_wants_shoot := false

var locking_target := false
var locking_time := 2.0

var lock_target : Spatial


func _ready() -> void:
	pass


func _process(delta : float) -> void:
	time_now += delta
	
	can_shoot = time_now >= next_times_to_fire[current_bullet] and not owner.input.turboing and ammo >= 1
	
	if not wants_shoot:
		not_eased_ammo += delta * 5
		ammo = clamp(pow(not_eased_ammo/MAX_AMMO, 3.0) * MAX_AMMO, 0, MAX_AMMO)
	else: #not old_wants_shoot:
		var a = pow(ammo/MAX_AMMO, 1.0/3.0) #* MAX_AMMO
		not_eased_ammo = clamp(a*MAX_AMMO, 0, MAX_AMMO)
		#var y = (ammo - 0.0) / (50 - 0.0)
		#not_eased_ammo = 1 + 1/10 * logWithBase(y, 3)
		#ammo = ease(not_eased_ammo/MAX_AMMO, 0.2) * MAX_AMMO
	
	if locking_target:
		if weakref(lock_target).get_ref():
			var direction := Vector3(lock_target.translation - owner.translation).normalized()
			var a = direction.dot(owner.global_transform.basis.z)
			if a < 0 or not can_shoot:
				cancel_locking_target()
		else:
			cancel_locking_target()
	
	""" Millorar codi si és possible
	if shooting:
		if get_tree().has_network_peer():
			rpc("shoot", shoot_target())
		else:
			shoot(shoot_target())
	"""
	old_wants_shoot = wants_shoot



sync func shoot(shoot_target = Vector3.ZERO) -> void:
	if current_bullet == 0:
		# $Audio.play()
		pass
	elif current_bullet == 1:
		$Audio2.play()
	
	ammo -= 1
	next_times_to_fire[current_bullet] = time_now + 1.0 / fire_rates[current_bullet]
	
	var bullet : ShipBullet
	if current_bullet == 0:
		bullet = bullet_scene.instance()
	elif current_bullet == 1:
		bullet = secondary_bullet_scene.instance()
	
	if bullet is MissileBullet:
		if lock_target:
			bullet.target = lock_target
	
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


func most_frontal_enenmy(big_ships := false) -> Spatial: # poder rutllar es +o- fàcil (comparar si concorda amb l'histoiral)
	var closest_dist := -INF
	var most_frontal_enenmy : Spatial = null
	
	var enemies := []
	for ship in get_tree().get_nodes_in_group("Ships"):
		if ship.pilot_man.blue_team != owner.pilot_man.blue_team:
			enemies.append(ship)
	if big_ships:
		for big_ship in get_tree().get_nodes_in_group("BigShips"):
			if big_ship.blue_team != owner.pilot_man.blue_team:
				enemies.append(big_ship)
	
	for body in enemies:
		var direction := Vector3(body.translation - owner.translation).normalized()
		var a = direction.dot(owner.global_transform.basis.z)
		
		if a > closest_dist:
			closest_dist = a
			most_frontal_enenmy = body
	
	return most_frontal_enenmy


func logWithBase(value, base): return log(value) / log(base)


func prepare_to_shoot_missile():
	if lock_target:
		locking_target = true
		if lock_missile_timer.is_stopped():
			lock_missile_timer.wait_time = locking_time
			lock_missile_timer.start()


func cancel_locking_target():
	$LockMissileTimer.stop()
	locking_target = false


func _on_LockMissileTimer_timeout():
	current_bullet = 1
	locking_target = false
	shoot()
