extends "AIShipState.gd"

var target_support_ship

func enter():
	# turbo, si en té
	owner.input.des_throttle = 1
	var own_support_ships : Array
	for support_ship in get_tree().get_nodes_in_group("SupportShips"):
		if support_ship.blue_team == owner.pilot_man.blue_team:
			own_support_ships.append(support_ship)
	if not own_support_ships:
		print("malament rayo")
	else:
		target_support_ship = own_support_ships[randi() % own_support_ships.size()]


func update(_delta):
	owner.input.target = target_support_ship.get_node("SupportArea").global_transform.origin
	if owner.get_node("HealthSystem").health > 700:
		emit_signal("finished", "choose_objective")
