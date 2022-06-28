extends "AIShipState.gd"


onready var timer : Timer = $OutOfRangeTimer

var enemy : Spatial
var enemy_wr : WeakRef

var attack_rel_pos : Vector3
var total_attack_pos : Vector3

var go_to_attack_rel_pos := true
var has_reached_enemy := false


func enter():
	attack_rel_pos = Vector3(rand_range(-200, 200), rand_range(-200, 200), rand_range(-200, 200)) # si va bé, fer-ho més gran


func update(_delta):
	if enemy_wr and enemy_wr.get_ref():
		if has_reached_enemy:
			if go_to_attack_rel_pos:
				owner.input.des_throttle = 1.0
				owner.input.target = total_attack_pos
				if owner.translation.distance_to(owner.input.target) < 100: # distancia a la attack pos
					go_to_attack_rel_pos = false
			else:
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
			if owner.translation.distance_to(owner.input.target) < 400: # distancia a l'enemic
				has_reached_enemy = true
				total_attack_pos = enemy.translation + attack_rel_pos
	else:
		change_enemy()


func change_enemy():
	var nearest_dist := INF
	for body in get_tree().get_nodes_in_group("Ships"):
		if body.pilot_man.blue_team != owner.pilot_man.blue_team:
			var new_dist = owner.translation.distance_to(body.translation)
			if new_dist < nearest_dist:
				nearest_dist = new_dist
				enemy = body
	"""
	elif body.is_in_group("BigShips"):
		if body.team_blue == owner.pilot_man.blue_team:
			return
	else: 
		return
	"""
	
	enemy_wr = weakref(enemy)
	owner.get_node("Shooting").target = enemy


func _on_OutOfRangeTimer_timeout():
	if enemy_wr and enemy_wr.get_ref():
		enter()
		total_attack_pos = enemy.translation + attack_rel_pos
		go_to_attack_rel_pos = true
