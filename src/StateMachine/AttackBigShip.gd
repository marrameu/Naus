extends "AttackEnemy.gd"


func enter():
	# temporal -> dos estats q estenen i q nomes canvien això
	var clos_dist := INF #1000
	var clos_enemy : Spatial = null
	for attack_ship in get_tree().get_nodes_in_group("AttackShips"):
		var dist : float = attack_ship.translation.distance_to(owner.translation)
		if dist < clos_dist:
			clos_enemy = attack_ship
			clos_dist = dist
	
	if clos_enemy:
		set_enemy()
	else:
		print("no attackship")
		emit_signal("finished", "choose_objective")


func change_rel_pos():
	attack_rel_pos = Vector3(rand_range(-1000, 1000), rand_range(-1000, 1000), rand_range(-1000, 1000))


func update(delta):
	if enemy_wr and enemy_wr.get_ref():
		attack_current_enemy()
	else:
		print(self, " malament rai")
	
	if owner.get_node("HealthSystem").health < 500:
		pass
		#print("kk")
		#escape()
