extends "AIShipState.gd"


func enter():
	# en procés de millora
	if get_parent().enemy_cs_shields_dead:
		emit_signal("finished", "attack_cs")
	elif get_parent().own_cs_shields_dead:
		emit_signal("finished", "attack_enemy")
	else:
		
		# DIFERÈNCIA > 1500
		if get_node("/root/Level").middle_point < rand_range(-1750, -1250):
			if owner.pilot_man.blue_team:
				emit_signal("finished", "attack_cs")
			else:
				emit_signal("finished", "attack_enemy")
		elif get_node("/root/Level").middle_point > rand_range(1250, 1750):
			if not owner.pilot_man.blue_team:
				emit_signal("finished", "attack_cs")
			else:
				emit_signal("finished", "attack_enemy")
		else:
			# DIFERÈNCIA < 1500
			if randi() % 3 < 2:
				print(owner.name, "attack")
				if randi() % 2:
					emit_signal("finished", "attack_enemy")
				else:
					emit_signal("finished", "attack_big_ship")
			else:
				print(owner.name, "go")
				emit_signal("finished", "attack_cs")


func update(_delta):
	pass

