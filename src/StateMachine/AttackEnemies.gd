extends "AIShipState.gd"


onready var timer : Timer = $OutOfRangeTimer

var enemy : Spatial
var enemy_wr : WeakRef

var attack_rel_pos : Vector3
var total_attack_pos : Vector3

var get_away_from_the_enemy := true
var has_reached_enemy := false


func enter():
	attack_rel_pos = Vector3(rand_range(-200, 200), rand_range(-200, 200), rand_range(-200, 200)) # si va bé, fer-ho més gran


func update(_delta):
	if enemy_wr and enemy_wr.get_ref():
		if has_reached_enemy:
			if get_away_from_the_enemy:
				owner.input.des_throttle = 1.0
				owner.input.target = total_attack_pos
				if owner.translation.distance_to(owner.input.target) < 100: # distancia a la attack pos
					get_away_from_the_enemy = false
			else: # disa
				if not owner.shooting.enemy_in_range and timer.is_stopped():
					timer.wait_time = rand_range(5, 14)
					timer.start()
					#no cal - elif owner.get_node("Shooting").enemy_in_range:
					#	timer.stop()
					# girar de pressa
				owner.input.des_throttle = 0.4
				owner.input.target = enemy.translation
		else:
			owner.input.des_throttle = 1.0
			owner.input.target = enemy.translation + attack_rel_pos # q si no sumes la relativa es xoquen
			if owner.translation.distance_to(enemy.translation) < 400: # distancia a l'enemic
				has_reached_enemy = true
				total_attack_pos = enemy.translation + attack_rel_pos
	else:
		change_enemy_to_nearest()


func change_enemy_to_nearest():
	var nearest_dist := INF
	# com el closest_enenmy() del shooting (cridar-lo)
	for body in get_tree().get_nodes_in_group("Ships"):
		if body.pilot_man.blue_team != owner.pilot_man.blue_team:
			var new_dist = owner.translation.distance_to(body.translation)
			if new_dist < nearest_dist:
				nearest_dist = new_dist
				set_enemy(body)
	"""
	elif body.is_in_group("BigShips"):
		if body.team_blue == owner.pilot_man.blue_team:
			return
	else: 
		return
	"""


func set_enemy(new_enemy):
	enemy = new_enemy
	enemy_wr = weakref(enemy)
	owner.get_node("Shooting").target = enemy
	has_reached_enemy = false
	get_away_from_the_enemy = true


func _on_OutOfRangeTimer_timeout():
	if enemy_wr and enemy_wr.get_ref():
		enter()
		total_attack_pos = enemy.translation + attack_rel_pos
		get_away_from_the_enemy = true


# si persegueix un enemic però li'n apareix un altre per davant, q ataqui al de devant
func _on_ShootingArea_body_entered(body):
	if body != enemy and body.is_in_group("Ships"):
		if body.pilot_man.blue_team != owner.pilot_man.blue_team:
			set_enemy(body)
