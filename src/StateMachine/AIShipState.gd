tool
extends "res://src/StateMachine/State.gd"

onready var own_cs : Spatial = get_node("/root/Level/BigShips/CapitalShipBlue") if owner.pilot_man.blue_team else get_node("/root/Level/BigShips/CapitalShipRed")


func _get_configuration_warning() -> String:
	var warning := ""
	if owner != Ship:
		warning = "L''owner' de l'estat no és una nau"
	return warning


func escape():
	emit_signal("finished", "escape")


func closest_enemy(min_dist : float = 750.0) -> Ship:
	var clos_dist := min_dist
	var clos_enemy : Ship
	for ship in get_tree().get_nodes_in_group("Ships"):
		if ship.pilot_man.blue_team != owner.pilot_man.blue_team:
			var dist = owner.translation.distance_to(ship.translation)
			if dist < clos_dist:
				clos_dist = dist
				clos_enemy = ship
	
	return clos_enemy


func closest_enemy_to_cs(plus_dist : float = 500.0) -> Ship:
	var closest_dsit : float = owner.translation.distance_to(own_cs.translation) + plus_dist
	var clos_enemy : Ship
	for ship in get_tree().get_nodes_in_group("Ships"):
		if ship.pilot_man.blue_team != owner.pilot_man.blue_team:
			var dist = ship.translation.distance_to(own_cs.translation)
			if dist < closest_dsit:
				closest_dsit = dist
				clos_enemy = ship
	
	return clos_enemy


func closest_big_ship(type : String):
	var closest_dsit := INF
	var clos_enemy : Spatial
	for ship in get_tree().get_nodes_in_group(type):
		if ship.blue_team != owner.pilot_man.blue_team:
			var dist = ship.translation.distance_to(own_cs.translation)
			if dist < closest_dsit:
				closest_dsit = dist
				clos_enemy = ship
	
	return clos_enemy
