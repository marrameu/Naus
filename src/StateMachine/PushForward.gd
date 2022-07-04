extends "AIShipState.gd"


func enter():
	print(owner, " entered ", name)
	owner.input.des_throttle = 1.0
	update_destination()


func update(delta):
	if owner.translation.distance_to(owner.input.target) < 250:
		update_destination()
	
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


func update_destination():
	if owner.pilot_man.blue_team:
		owner.input.target = Vector3(get_node("/root/Level").middle_point - 2000, rand_range(-350, 350), rand_range(-700, 700))
	else:
		owner.input.target = Vector3(get_node("/root/Level").middle_point + 2000, rand_range(-350, 350), rand_range(-700, 700))