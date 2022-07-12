extends "AIShipState.gd"

var my_team_big_ships_wo_shields : Array

# CHOOSE OBEJCTIVE DESTRUCTION BATTLE

func enter():
	print(owner, " entered ", name)
	
	clean_bigships_w_shields()
	
	for ship in my_team_big_ships_wo_shields:
		# aquesta comprovació fa que vagi per ordre de priotritats
		if ship.is_in_group("CapitalShips") or ship.is_in_group("SupportShips") or ship.is_in_group("AttackShips"):
			get_parent().states_map["defend_bs"].target_ship = ship
			emit_signal("finished", "defend_bs")
			return
	
	# ESCUTS
	#if get_parent().enemy_cs_shields_dead: # o de les de suport
	#	emit_signal("finished", "attack_cs")
	
	# TOTES LES NAUS PRÒPIES TENEN ESCUTS
	var aneu_guanyant := false
	var us_van_guanyant := false
	if get_node("/root/Level").middle_point < -get_parent().point_of_change:
		if owner.pilot_man.blue_team:
			aneu_guanyant = true
		else:
			us_van_guanyant = true
	elif get_node("/root/Level").middle_point > get_parent().point_of_change:
		if not owner.pilot_man.blue_team:
			aneu_guanyant = true
		else:
			us_van_guanyant = true
	
	if us_van_guanyant:
		var closest_attack_ship : Spatial = closest_big_ship("AttackShips")
		if closest_attack_ship:
			var attack_big_ship := true
			if closest_attack_ship.translation.distance_to(owner.translation) > 1000:
					attack_big_ship = false
			elif closest_attack_ship.get_node("HealthSystem").shield:
				if randi() % 2:
					attack_big_ship = false
			if attack_big_ship:
				owner.shooting.target = closest_attack_ship
				emit_signal("finished", "attack_big_ship")
				return
		
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
		
	elif aneu_guanyant:
		print("nemg uanyant")
		var closest_attack_ship : Spatial = closest_big_ship("AttackShips")
		if closest_attack_ship:
			var attack_big_ship := true
			if closest_attack_ship.translation.distance_to(owner.translation) > 1000:
				attack_big_ship = false
			if attack_big_ship:
				owner.shooting.target = closest_attack_ship
				emit_signal("finished", "attack_big_ship")
				print("atacemlahiun4")
				return
		
		var closest_support_ship : Spatial = closest_big_ship("SupportShips")
		if closest_support_ship:
			owner.shooting.target = closest_support_ship
			print("support ship, fora!!")
			emit_signal("finished", "attack_big_ship")
		else:
			emit_signal("finished", "attack_cs")
	else:
		# DIFERÈNCIA < 1500
		
		var closest_attack_ship : Spatial = closest_big_ship("AttackShips")
		if closest_attack_ship:
			var attack_big_ship := true
			if closest_attack_ship.translation.distance_to(owner.translation) > 1000:
				attack_big_ship = false
			elif closest_attack_ship.get_node("HealthSystem").shield:
				if randi() % 2:
					attack_big_ship = false
			if attack_big_ship:
				owner.shooting.target = closest_attack_ship
				emit_signal("finished", "attack_big_ship")
				return
		
		# potser, si costa molt avançar, fer que si no hi ha més que un o dos enemics vius (i tot l'equip teu viu, ço és, diferència de 3) ja podeu push forward
		if number_of_my_team_ships() - number_of_enemy_ships() <= 2: # millor fer-ho en funció del middle point
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
		
		emit_signal("finished", "push_forward")
		
		"""
		if randi() % 2:
			emit_signal("finished", "patrol_middle_point")
			print(owner.name, "patrol")
		else:
			emit_signal("finished", "attack_big_ship")
			print(owner.name, "attack big_ship")
		"""


func _on_AIShip_enemy_attack_ship_shields_down(ship):
	if ship.blue_team == owner.pilot_man.blue_team:
		my_team_big_ships_wo_shields.append(ship)


func clean_bigships_w_shields():
	var pos : int = 0
	for ship in my_team_big_ships_wo_shields:
		var remove := false
		if not ship:
			remove = true
		elif not weakref(ship).get_ref():
			remove = true
		elif ship.get_node("HealthSystem").shield:
			remove = true
		if remove:
			my_team_big_ships_wo_shields.remove(pos)
			pos -= 1
		pos += 1
