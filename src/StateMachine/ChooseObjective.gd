extends "AIShipState.gd"

# CHOOSE OBEJCTIVE DESTRUCTION BATTLE

func enter():
	print(owner, " entered ", name)
	# en procés de millora
	if get_parent().enemy_cs_shields_dead:
		emit_signal("finished", "attack_cs")
	elif get_parent().own_cs_shields_dead:
		emit_signal("finished", "attack_enemy")
	else:
		var aneu_guanyant := false
		var us_van_guanyant := false
		if get_node("/root/Level").middle_point < rand_range(-1500, -1000):
			if owner.pilot_man.blue_team:
				aneu_guanyant = true
			else:
				us_van_guanyant = true
		elif get_node("/root/Level").middle_point > rand_range(1000, 1500):
			if not owner.pilot_man.blue_team:
				aneu_guanyant = true
			else:
				us_van_guanyant = true
		
		if us_van_guanyant:
			var closest_enemy = closest_enemy()
			if closest_enemy:
				owner.shooting.target = closest_enemy
				emit_signal("finished", "attack_enemy")
				return
			
			var closest_enemy_to_cs = closest_enemy_to_cs()
			if closest_enemy_to_cs:
				owner.shooting.target = closest_enemy_to_cs
				emit_signal("finished", "attack_enemy")
				return
			else:
				print("malament ray")
			
		elif aneu_guanyant:
			emit_signal("finished", "attack_cs")
		else:
			# DIFERÈNCIA < 1500
			"""
			if get_node("/root/Level").battle_time < 30:
				print(owner.name, "patrol<30")
				emit_signal("finished", "patrol_middle_point")
				# go to middle point -> attack_clos_enemy
			else:
			"""
			
			# porser, si costa molt avançar, fer que si no hi ha més que un o dos enemics vius (i tot l'equip teu viu, ço és, diferència de 3) ja podeu push forward
			var closest_enemy = closest_enemy()
			if closest_enemy:
				owner.shooting.target = closest_enemy
				emit_signal("finished", "attack_enemy")
				return
			
			var closest_enemy_to_cs = closest_enemy_to_cs()
			if closest_enemy_to_cs:
				if closest_enemy_to_cs.translation.distance_to(own_cs.translation) < owner.translation.distance_to(own_cs.translation) + 500:
					owner.shooting.target = closest_enemy_to_cs
					emit_signal("finished", "attack_enemy")
					return
			
			emit_signal("finished", "push_forward")
			
			"""
			if randi() % 2:
				emit_signal("finished", "patrol_middle_point")
				print(owner.name, "patrol")
			else:
				emit_signal("finished", "attack_big_ship")
				print(owner.name, "attack big_ship")
			"""
